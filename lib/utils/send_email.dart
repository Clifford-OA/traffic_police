import 'dart:convert';

import 'package:http/http.dart' as http;

class SendEmailClass {
  Future sendEmail({toName, description, fineAmount, toEmail}) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_d7wq1ps';
    const templateId = 'template_ynovx6k';
    const userId = '9WODARR5Zm2srqUTX';

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost'
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_name': toName,
            'description': description,
            'fine_amount': fineAmount,
            'email': toEmail
          }
        }));
    print(response);
    return response;
  }
}
