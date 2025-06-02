import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controller/note_controller.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.find<NoteController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => controller.sortBy.value =
                controller.sortBy.value == 'title' ? 'date' : 'title',
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (val) => controller.search.value = val,
            ),
          ),

          // Label filter chips
          Obx(() {
            final labels = controller.allLabels;
            final selected = controller.selectedLabel.value;

            if (labels.isEmpty) return const SizedBox.shrink();

            return SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ChoiceChip(
                    label: const Text('All', style: TextStyle(fontSize: 12)),
                    selected: selected.isEmpty,
                    onSelected: (_) => controller.selectedLabel.value = '',
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...labels.map(
                    (label) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          label,
                          style: const TextStyle(fontSize: 12),
                        ),
                        selected: selected == label,
                        onSelected: (_) =>
                            controller.selectedLabel.value = label,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              final notes = controller.filteredNotes;
              if (notes.isEmpty) {
                return const Center(child: Text('No notes found'));
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: notes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final note = notes[i];
                  return Dismissible(
                    key: Key(note.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      final deletedNote = note;
                      controller.deleteNote(deletedNote);

                      Get.snackbar(
                        'Note deleted',
                        '',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Get
                            .theme
                            .colorScheme
                            .surfaceContainerHighest, 
                        colorText: Get
                            .theme
                            .colorScheme
                            .onSurfaceVariant, 
                        margin: const EdgeInsets.all(12),
                        borderRadius: 12,
                        mainButton: TextButton(
                          onPressed: () {
                            controller.addNote(deletedNote);
                            Get.closeCurrentSnackbar();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Get
                                .theme
                                .colorScheme
                                .primary, 
                            textStyle: Get
                                .textTheme
                                .labelLarge, 
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text('UNDO'),
                        ),
                        duration: const Duration(seconds: 3),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          note.title,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd().format(note.updatedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () => Get.toNamed('/note', arguments: note),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/note'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
