class CodeEvent {
  const CodeEvent(this.kind, {this.language, this.toolUseId});

  final String kind;
  final String? language;
  final String? toolUseId;
}

final _commitRe = RegExp(r'git\s+commit(?![\w-])', caseSensitive: false);
final _testRe = RegExp(
  r'\b(?:pytest|jest|vitest|mocha|phpunit|rspec|ctest|tox|nosetests)\b(?!\.)'
  r'|\b(?:flutter|dart|npm|yarn|pnpm|bun|go|cargo|mvn|gradle|rails|rake|python|deno)\s+'
  r'(?:(?:run|\S+\.py)\s+)?test\b(?!\.)',
  caseSensitive: false,
);
final _deleteRe = RegExp(
  r'(?:^|[\s;&|(`])rm\s+-?\w|\bgit\s+rm\b|\brmdir\b',
  caseSensitive: false,
);

const _langByExt = {
  'dart': 'Dart',
  'py': 'Python',
  'ts': 'TypeScript',
  'tsx': 'TypeScript',
  'js': 'JavaScript',
  'jsx': 'JavaScript',
  'mjs': 'JavaScript',
  'go': 'Go',
  'rs': 'Rust',
  'java': 'Java',
  'kt': 'Kotlin',
  'swift': 'Swift',
  'rb': 'Ruby',
  'c': 'C',
  'h': 'C',
  'cpp': 'C++',
  'cc': 'C++',
  'hpp': 'C++',
  'cs': 'C#',
  'php': 'PHP',
  'html': 'HTML',
  'css': 'CSS',
  'scss': 'CSS',
  'md': 'Markdown',
  'json': 'JSON',
  'yaml': 'YAML',
  'yml': 'YAML',
  'sh': 'Shell',
  'bash': 'Shell',
  'sql': 'SQL',
  'vue': 'Vue',
  'svelte': 'Svelte',
  'm': 'Objective-C',
  'mm': 'Objective-C',
  'cjs': 'JavaScript',
  'mts': 'TypeScript',
  'cts': 'TypeScript',
  'kts': 'Kotlin',
  'scala': 'Scala',
  'gradle': 'Gradle',
  'toml': 'TOML',
  'xml': 'XML',
};

String? _langOf(String? path) {
  if (path == null) return null;
  final slash = path.lastIndexOf('/');
  final name = slash >= 0 ? path.substring(slash + 1) : path;
  final dot = name.lastIndexOf('.');
  if (dot <= 0 || dot == name.length - 1) return null;
  return _langByExt[name.substring(dot + 1).toLowerCase()];
}

List<CodeEvent> classifyEntry(Map<String, dynamic> obj) {
  final type = obj['type'];
  final message = obj['message'];
  if (message is! Map) return const [];
  final content = message['content'];
  if (content is! List) return const [];
  final out = <CodeEvent>[];
  if (type == 'assistant') {
    for (final block in content) {
      if (block is! Map || block['type'] != 'tool_use') continue;
      final name = block['name'] as String? ?? '';
      final input = block['input'];
      final id = block['id'] as String?;
      if (name == 'Bash') {
        final cmd = (input is Map ? input['command'] as String? : null) ?? '';
        if (_commitRe.hasMatch(cmd)) {
          out.add(CodeEvent('commit', toolUseId: id));
        }
        if (_testRe.hasMatch(cmd)) {
          out.add(CodeEvent('test', toolUseId: id));
        }
        if (_deleteRe.hasMatch(cmd)) {
          out.add(CodeEvent('delete', toolUseId: id));
        }
      } else if (name == 'Edit' ||
          name == 'Write' ||
          name == 'MultiEdit' ||
          name == 'NotebookEdit') {
        final path = input is Map
            ? (input['file_path'] as String? ??
                  input['notebook_path'] as String?)
            : null;
        out.add(CodeEvent('edit', language: _langOf(path), toolUseId: id));
      }
    }
  } else if (type == 'user') {
    for (final block in content) {
      if (block is! Map || block['type'] != 'tool_result') continue;
      final tid = block['tool_use_id'] as String?;
      out.add(
        CodeEvent(
          block['is_error'] == true ? 'error' : 'result',
          toolUseId: tid,
        ),
      );
    }
  }
  return out;
}
