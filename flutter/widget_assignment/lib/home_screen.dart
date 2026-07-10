import 'package:flutter/material.dart';
import 'detail_screen.dart';

// ── Data arrays ───────────────────────────────────────────────────────────────

const List<String> titles = [
  'Text',
  'Container',
  'Row',
  'Column',
  'Stack',
  'Image',
  'Icon',
  'ElevatedButton',
  'TextField',
  'Scaffold',
  'AppBar',
  'ListView',
  'GridView',
  'Padding',
  'Align',
  'SizedBox',
  'Card',
  'CircleAvatar',
  'Checkbox',
  'FloatingActionButton',
];

const List<String> subtitles = [
  'Displays styled text',
  'Box with colour & decoration',
  'Horizontal child layout',
  'Vertical child layout',
  'Overlapping children',
  'Shows asset or network image',
  'Material Design glyph',
  'Tappable raised button',
  'Keyboard text input field',
  'Basic visual layout structure',
  'Top app bar with actions',
  'Scrollable vertical list',
  '2D scrollable grid',
  'Insets child by given padding',
  'Positions child inside parent',
  'Fixed-size spacing box',
  'Rounded elevated surface',
  'Circular user avatar',
  'Boolean on/off toggle',
  'Circular floating button',
];

const List<IconData> icons = [
  Icons.text_fields,
  Icons.crop_square,
  Icons.view_column,
  Icons.view_agenda,
  Icons.layers,
  Icons.image,
  Icons.star,
  Icons.smart_button,
  Icons.edit,
  Icons.space_dashboard,
  Icons.web_asset,
  Icons.list,
  Icons.grid_view,
  Icons.padding,
  Icons.align_horizontal_center,
  Icons.photo_size_select_small,
  Icons.credit_card,
  Icons.account_circle,
  Icons.check_box,
  Icons.add_circle,
];

// ── Home Screen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget Explorer'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'List'),
              Tab(icon: Icon(Icons.grid_view), text: 'Square'),
              Tab(icon: Icon(Icons.view_stream), text: 'Compact'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_ListView(), _GridView(), _CompactView()],
        ),
      ),
    );
  }
}

// ── Helper ────────────────────────────────────────────────────────────────────

void _goToDetail(BuildContext context, int i) => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => DetailScreen(index: i)),
);

// ── Tab 1 — List ──────────────────────────────────────────────────────────────

class _ListView extends StatelessWidget {
  const _ListView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, i) => ListTile(
        leading: Icon(icons[i]),
        title: Text(titles[i]),
        subtitle: Text(subtitles[i]),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => _goToDetail(context, i),
      ),
    );
  }
}

// ── Tab 2 — Square (Grid) ─────────────────────────────────────────────────────

class _GridView extends StatelessWidget {
  const _GridView();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: titles.length,
      itemBuilder: (context, i) => GestureDetector(
        onTap: () => (context, i),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons[i], size: 36),
              const SizedBox(height: 8),
              Text(
                titles[i],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  subtitles[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 3 — Compact ───────────────────────────────────────────────────────────

class _CompactView extends StatelessWidget {
  const _CompactView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: titles.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => InkWell(
        onTap: () => _goToDetail(context, i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(child: Icon(icons[i], size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titles[i],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${i + 1}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
