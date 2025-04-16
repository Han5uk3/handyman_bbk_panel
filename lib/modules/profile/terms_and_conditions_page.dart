import 'package:flutter/material.dart';

import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        "Terms & Conditions",
        context,
        isCenter: true,
        isneedtopop: true,
        iswhite: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.justify,
                style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
                "Welcome to Handyman Partner, the official app for registered workers and administrators associated with the Handyman platform. These Terms and Conditions govern the use of this application by service providers (electricians, plumbers, etc.) and administrative personnel. By registering or accessing the app, you agree to abide by these Terms. If you do not agree, please refrain from using the app.",
              ),
              _buildtermscontent(
                "1. Overview",
                "Handyman Partner is a companion platform to the Handyman app. It allows workers to register and manage job requests, while providing admins with tools to view, monitor, and assign workers to service requests. It also enables real-time worker location tracking to facilitate scheduling efficiency and service transparency.",
              ),
              _buildtermscontent(
                "2. Worker Registration and Responsibilities",
                "Workers must register via Handyman Partner using valid identification and company affiliation details. By registering, you confirm that all provided information is accurate and truthful. Workers are responsible for updating their availability, responding promptly to assigned tasks, and maintaining professional conduct during service delivery. Providing false information or misconduct on-site may lead to suspension or permanent termination from the platform.",
              ),
              _buildtermscontent(
                "3. Admin Role and Access",
                "Administrators have the ability to view and manage all registered workers, track ongoing service requests, and assign workers based on availability and proximity. Admins also have access to data including worker performance metrics, real-time location (with consent), and job completion statuses. Admins are expected to use this access responsibly and solely for operational purposes. Unauthorized use of personal data or misuse of admin privileges may result in account suspension or legal action.",
              ),
              _buildtermscontent(
                "4. Location Tracking",
                "Handyman Partner uses real-time GPS tracking to assist in assigning the nearest available worker to a customer’s request. By using the app, workers consent to share their location during working hours. This data is visible only to administrators and is used strictly for operational purposes. Location tracking is disabled when workers are off-duty.",
              ),
              _buildtermscontent(
                "5. Service Request Management",
                "Workers will receive notifications for newly assigned service jobs. It is their responsibility to accept, reject, or request rescheduling in a timely manner. Upon accepting a job, the worker must arrive on time and perform the service to the best of their ability. Job completion status must be updated in the app, and any issues should be reported through the internal feedback system. Admins can monitor the progress of every request and reassign or cancel tasks as needed to ensure smooth operations.",
              ),
              _buildtermscontent(
                "6. Payments and Earnings",
                "All customer payments are handled directly through the Handyman app via Apple Pay and card transactions. Workers are compensated according to the company’s payout model. Handyman Partner does not process payments directly within the app. Earnings and job history are visible to workers via their dashboard for transparency.",
              ),
              _buildtermscontent("7. Reviews and Ratings",
                  "After each completed job, customers may leave a review and rating based on their experience. These ratings contribute to worker profiles and help maintain service quality. Workers may request the removal of clearly false or offensive reviews, which will be reviewed by the admin team. Consistently low ratings or poor performance may affect job assignments and account standing."),
              _buildtermscontent("8. Data Privacy and Security",
                  "All user data, including location, job history, and communication logs, is stored securely. Only authorized personnel have access to this information. Workers have the right to request access or deletion of their personal data, subject to company retention and legal requirements. For more information, please refer to the Handyman Privacy Policy."),
              _buildtermscontent("9. Termination",
                  "Handyman reserves the right to terminate access to the Handyman Partner app at any time for violations of these Terms, fraudulent behavior, inactivity, or misconduct. Workers and admins will be notified via email in such cases."),
              _buildtermscontent(
                "10. Updates and Modifications",
                "These Terms may be updated periodically. We will notify you of any significant changes through the app or via email. Continued use of the app after such updates constitutes acceptance of the new Terms.",
              ),
              _buildtermscontent(
                "11. Modifications",
                "We may update or revise these Terms at any time. If we make significant changes, we will notify users through the app or by other means. Continued use of Handyman after changes are made constitutes your acceptance of the updated Terms.",
              ),
              _buildtermscontent(
                "12. Governing Law",
                "These Terms and Conditions are governed by and interpreted according to the laws of Saudi Arabia. Any disputes will be resolved in accordance with these laws.",
              ),
              _buildtermscontent(
                "13. Contact",
                "For questions or concerns about these Terms, please reach out to our team: ",
              ),
              SizedBox(height: 12),
              Text(
                "Email: [email]",
                style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
              ),
              Text(
                "Phone: [phone number]",
                style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  _buildtermscontent(head, desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        HandyLabel(text: head, isBold: true),
        SizedBox(height: 20),
        Text(
          textAlign: TextAlign.justify,
          style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
          desc,
        ),
      ],
    );
  }
}
