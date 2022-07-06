// TODO Implement this library.
import 'package:flutter/material.dart';

import '../model/transaction.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, double amount, bool isExpense) onClickedDone;

  const TransactionDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  /*When creating the form, provide a GlobalKey. This uniquely identifies the Form,
   and allows validation of the form in a later step.*/
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      amountController.text = transaction.amount.toString();
      isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),
              buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
    controller: nameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Name',
    ),
    validator: (name) =>
    name != null && name.isEmpty ? 'Enter a name' : null,
  );

  Widget buildAmount() => TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Amount',
    ),
    keyboardType: TextInputType.number,
    validator: (amount) => amount != null && double.tryParse(amount) == null
        ? 'Enter a valid number'
        : null,
    controller: amountController,
  );

  Widget buildRadioButtons() => Column(
    children: [
      RadioListTile<bool>(
        title: Text('Expense'),
        value: true,
        groupValue: isExpense,
        onChanged: (value) => setState(() => isExpense = value!),
      ),
      RadioListTile<bool>(
        title: Text('Income'),
        value: false,
        groupValue: isExpense,
        onChanged: (value) => setState(() => isExpense = value!),
      ),
    ],
  );

  Widget buildCancelButton(BuildContext context) => TextButton(
    child: Text('Cancel'),
    onPressed: () => Navigator.of(context).pop(),
  );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final amount = double.tryParse(amountController.text) ?? 0;// amount==amountcontroller but if amntcontroller is null then amount is 0.
          widget.onClickedDone(name, amount, isExpense);

          Navigator.of(context).pop();
        }
      },
    );
  }
}