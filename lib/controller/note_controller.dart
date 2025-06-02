import 'package:get/get.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/service/note_service.dart';

class NoteController extends GetxController {
  final NoteService service = Get.find();

  var notes = <Note>[].obs;
  var search = ''.obs;
  var sortBy = 'date'.obs;
  var allLabels = <String>[].obs;
  var selectedLabel = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await service.getNotes();
    notes.assignAll(data);
    _extractLabels();
  }

  Future<void> addNote(Note note) async {
    await service.addNote(note);
    notes.add(note);
    _extractLabels();
  }

  Future<void> updateNote(Note note) async {
    await service.updateNote(note);
    final idx = notes.indexWhere((n) => n.id == note.id);
    if (idx != -1) {
      notes[idx] = note;
      _extractLabels();
    }
  }

  Future<void> deleteNote(Note note) async {
    await service.deleteNote(note.id);
    notes.removeWhere((n) => n.id == note.id);
    _extractLabels();
  }

  void _extractLabels() {
    final labelSet = <String>{};
    for (var note in notes) {
      labelSet.addAll(note.labels);
    }
    allLabels.assignAll(labelSet.toList());
  }

  List<Note> get filteredNotes {
    final q = search.value.toLowerCase();
    final label = selectedLabel.value;

    var filtered = notes.where((n) {
      final matchesSearch = n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
      final matchesLabel = label.isEmpty || n.labels.contains(label);
      return matchesSearch && matchesLabel;
    }).toList();

    if (sortBy.value == 'title') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else {
      filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return filtered;
  }
}
