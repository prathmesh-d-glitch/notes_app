import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/controller/note_controller.dart';
import 'package:notes_app/models/note.dart';

class NoteScreen extends StatelessWidget {
  final controller = Get.find<NoteController>();
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final labelCtrl = TextEditingController();

  final RxList<String> selectedLabels = <String>[].obs;

  NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Note? note = Get.arguments;
    final isEdit = note != null;

    if (isEdit) {
      titleCtrl.text = note!.title;
      contentCtrl.text = note.content;
      selectedLabels.assignAll(note.labels);
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: isEdit ? 'Update' : 'Create',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final now = DateTime.now();
                final newNote = Note(
                  id: isEdit ? note!.id : UniqueKey().toString(),
                  title: titleCtrl.text.trim(),
                  content: contentCtrl.text.trim(),
                  createdAt: isEdit ? note!.createdAt : now,
                  updatedAt: now,
                  labels: selectedLabels.toList(),
                );
                isEdit ? controller.updateNote(newNote) : controller.addNote(newNote);
                Get.back();
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleCtrl,
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: theme.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 6),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter a title' : null,
              ),

              const SizedBox(height: 8),

              
              Expanded(
                child: TextFormField(
                  controller: contentCtrl,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your note...',
                    hintStyle: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 8),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Enter content' : null,
                ),
              ),

              const SizedBox(height: 12),

              Obx(() {
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: controller.allLabels.map((label) {
                    final isSelected = selectedLabels.contains(label);
                    return FilterChip(
                      label: Text(label),
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: theme.colorScheme.primaryContainer,
                      onSelected: (selected) {
                        selected
                            ? selectedLabels.add(label)
                            : selectedLabels.remove(label);
                      },
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: labelCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Add label',
                        border: UnderlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addLabel(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addLabel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addLabel() {
    final label = labelCtrl.text.trim();
    if (label.isNotEmpty && !controller.allLabels.contains(label)) {
      controller.allLabels.add(label);
      selectedLabels.add(label);
      labelCtrl.clear();
    }
  }
}
