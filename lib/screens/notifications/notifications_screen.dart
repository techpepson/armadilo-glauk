import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glauk/data/notifications.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsData _data = NotificationsData();
  List<AppNotification> _items = [];
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _items = _data.getAll();
  }

  Future<void> _onRefresh() async {
    setState(() => _refreshing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _items = _data.getAll();
      _refreshing = false;
    });
  }

  void _openDetails(AppNotification n) async {
    _data.markAsRead(n.id);
    setState(() {});

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Constants.primary.withValues(
                          alpha: 0.15,
                        ),
                        backgroundImage:
                            n.avatarUrl != null
                                ? NetworkImage(n.avatarUrl!)
                                : null,
                        child:
                            n.avatarUrl == null
                                ? Text(
                                  _initials(n.sender),
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${n.sender} • ${_relativeTime(n.receivedAt)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: Constants.textColor.withAlpha(150),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    n.body,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Constants.textColor.withAlpha(220),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (!n.isRead)
                        ElevatedButton.icon(
                          onPressed: () {
                            _data.markAsRead(n.id);
                            setState(() {});
                            Navigator.of(context).maybePop();
                          },
                          icon: const Icon(Icons.mark_email_read_outlined),
                          label: const Text('Mark as read'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _data.deleteById(n.id);
                          setState(() {
                            _items = _data.getAll();
                          });
                          Navigator.of(context).maybePop();
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _markAllRead() {
    _data.markAllAsRead();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            onPressed: _items.any((n) => !n.isRead) ? _markAllRead : null,
            icon: const Icon(Icons.done_all_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Constants.primary,
          child:
              _items.isEmpty
                  ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Icon(
                        Icons.notifications_none_outlined,
                        size: 64,
                        color: Constants.textColor.withAlpha(120),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          _refreshing ? 'Refreshing…' : 'No notifications yet',
                          style: textTheme.titleMedium?.copyWith(
                            color: Constants.textColor.withAlpha(180),
                          ),
                        ),
                      ),
                    ],
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final n = _items[index];
                      return Dismissible(
                        key: ValueKey(n.id),
                        direction: DismissDirection.endToStart,
                        background: _buildSwipeBackground(context),
                        onDismissed: (_) {
                          _data.deleteById(n.id);
                          setState(() => _items = _data.getAll());
                        },
                        child: _NotificationTile(
                          notification: n,
                          onTap: () => _openDetails(n),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(Icons.delete_outline, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  static String _relativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final weeks = (diff.inDays / 7).floor();
    return weeks <= 1 ? '1w ago' : '${weeks}w ago';
  }

  static String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r"\s+")).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final borderColor =
        n.isRead
            ? theme.dividerColor.withAlpha(60)
            : Constants.primary.withValues(alpha: 80);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Constants.primary.withValues(alpha: 0.15),
                    backgroundImage:
                        n.avatarUrl != null ? NetworkImage(n.avatarUrl!) : null,
                    child:
                        n.avatarUrl == null
                            ? Text(
                              _NotificationsScreenState._initials(n.sender),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : null,
                  ),
                  if (!n.isRead)
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Constants.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  n.isRead
                                      ? Constants.textColor.withAlpha(200)
                                      : Constants.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _NotificationsScreenState._relativeTime(n.receivedAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: Constants.textColor.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Constants.textColor.withAlpha(180),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _CategoryChip(label: n.category ?? 'general'),
                        const Spacer(),
                        if (!n.isRead)
                          Icon(
                            Icons.brightness_1,
                            size: 8,
                            color: Constants.primary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
