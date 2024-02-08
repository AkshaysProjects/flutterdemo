import 'package:flutter/material.dart';
import 'package:flutterdemo/models/post_model.dart';

// Defines a dialog widget for creating or editing a post.
class PostDialog extends StatelessWidget {
  final Post? post;
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final TextEditingController userIdController;
  final Function(String title, String body, int? userId) onSave;

  // Add a GlobalKey for the Form widget
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Constructor initializes form controllers and callback function.
  PostDialog({
    Key? key,
    required this.titleController,
    required this.bodyController,
    required this.userIdController,
    required this.onSave,
    this.post,
  }) : super(key: key);

  // Generates decoration for text form fields.
  InputDecoration _getInputDecoration(BuildContext context, String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: _getOutlineInputBorder(Colors.grey[300]!),
      enabledBorder: _getOutlineInputBorder(Colors.grey[300]!),
      focusedBorder: _getOutlineInputBorder(Theme.of(context).primaryColor),
    );
  }

  // Creates an outline border with the specified color.
  OutlineInputBorder _getOutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(borderSide: BorderSide(color: borderColor));
  }

  // Builds the main structure of the dialog.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(post == null ? 'Create Post' : 'Edit Post'),
      content: SingleChildScrollView(
        // Wrap the form fields with a Form widget and associate it with the _formKey
        child: Form(
          key: _formKey,
          child: _buildFormFields(context),
        ),
      ),
      actions: _buildActions(context),
    );
  }

  // Create form fields for user input.
  Widget _buildFormFields(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          width: 400,
          child: TextFormField(
            controller: userIdController,
            decoration: _getInputDecoration(context, 'User ID'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 400,
          child: TextFormField(
            controller: titleController,
            minLines: 1,
            maxLines: 3,
            decoration: _getInputDecoration(context, 'Title'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 400,
          child: TextFormField(
            controller: bodyController,
            minLines: 5,
            maxLines: null,
            decoration: _getInputDecoration(context, 'Body'),
            keyboardType: TextInputType.multiline,
          ),
        ),
      ],
    );
  }

  // Define actions for cancel and save within the dialog.
  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => _handleSave(context),
        child: const Text('Save'),
      ),
    ];
  }

  // Handle the save action; validate the form and invoke onSave callback.
  void _handleSave(BuildContext context) {
    // Use the form key to validate the form
    if (_formKey.currentState!.validate()) {
      onSave(
        titleController.text,
        bodyController.text,
        userIdController.text.isNotEmpty
            ? int.tryParse(userIdController.text)
            : null,
      );
      Navigator.of(context).pop();
    }
  }
}
