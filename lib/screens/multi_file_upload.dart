import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MultipleFileUpload extends StatelessWidget {
  final List<PlatformFile> selectedFiles;
  final Function(List<PlatformFile> pickedFiles) onFilesPicked;
  final Function(int index) onFileRemoved;

  const MultipleFileUpload({
    super.key,
    required this.onFilesPicked,
    required this.selectedFiles,
    required this.onFileRemoved,
  });

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        onFilesPicked(result.files);
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedFiles.isNotEmpty) ...[
              Text(
                'Selected Files (${selectedFiles.length}):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = selectedFiles[index];
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(file.name),
                    subtitle: Text('Size: ${(file.size / 1024).toStringAsFixed(2)} KB'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onFileRemoved(index),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.file_upload, size: 18, color: Colors.white),
              label: const Text('Select Files'),
            ),
          ],
        ),
      ),
    );
  }
}
