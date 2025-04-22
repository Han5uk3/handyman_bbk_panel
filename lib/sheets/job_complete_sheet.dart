import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:image_picker/image_picker.dart';

class JobCompletionBottomSheet extends StatefulWidget {
  final String bookingId;

  const JobCompletionBottomSheet({
    super.key,
    required this.bookingId,
  });

  @override
  _JobCompletionBottomSheetState createState() =>
      _JobCompletionBottomSheetState();
}

class _JobCompletionBottomSheetState extends State<JobCompletionBottomSheet> {
  bool _processingComplete = false;
  final ImagePicker _picker = ImagePicker();
  File? _afterImage;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _afterImage = File(pickedImage.path);
      });
    }
  }

  void _submitCompletion() {
    if (_afterImage == null) {
      HandySnackBar.show(
          context: context,
          message: 'Please upload an image before completing.',
          isTrue: false);
      return;
    }

    setState(() {
      _processingComplete = true;
    });

    context.read<WorkersBloc>().add(
          EndWorkAndMarkAsCompletedEvent(
            bookingId: widget.bookingId,
            afterImage: _afterImage,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkersBloc, WorkersState>(
      listener: (context, state) {
        if (state is EndJobSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Job completed successfully!')),
          );
        } else if (state is EndJobFailure) {
          setState(() {
            _processingComplete = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to complete job. Please try again.')),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Complete the Job',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _afterImage == null
                  ? GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Upload After-Work Image'),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _afterImage!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _afterImage = null;
                              });
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black.withOpacity(0.6),
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _processingComplete ? null : _submitCompletion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _processingComplete
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Processing...'),
                        ],
                      )
                    : Text('Complete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
