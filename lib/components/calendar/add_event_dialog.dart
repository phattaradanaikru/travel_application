import 'package:flutter/material.dart';
import 'package:travel_application/data/model/traveleventmodel.dart';

class AddEventDialog extends StatefulWidget {
  final DateTime selectedDate;
  final TravelEvent? existingEvent;

  const AddEventDialog({
    super.key,
    required this.selectedDate,
    this.existingEvent,
  });

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  EventType _selectedType = EventType.general;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;

    if (widget.existingEvent != null) {
      final event = widget.existingEvent!;
      _titleController.text = event.title;
      _descriptionController.text = event.description ?? '';
      _locationController.text = event.location ?? '';
      _notesController.text = event.notes ?? '';
      _selectedDate = event.date;
      _selectedType = event.type;

      if (event.startTime != null) {
        _startTime = TimeOfDay.fromDateTime(event.startTime!);
      }
      if (event.endTime != null) {
        _endTime = TimeOfDay.fromDateTime(event.endTime!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _startTime = time;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _endTime = time;
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();

      DateTime? startDateTime;
      DateTime? endDateTime;

      if (_startTime != null) {
        startDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
      }

      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }

      final event = TravelEvent(
        id: widget.existingEvent?.id ?? 'event_${now.millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        date: _selectedDate!,
        startTime: startDateTime,
        endTime: endDateTime,
        location:
            _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
        type: _selectedType,
        notes:
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
        createdAt: widget.existingEvent?.createdAt ?? now,
      );

      Navigator.of(context).pop(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_note, color: colorScheme.onPrimaryContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.existingEvent != null
                          ? 'แก้ไขกิจกรรม'
                          : 'เพิ่มกิจกรรม',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'ชื่อกิจกรรม',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'กรุณาใส่ชื่อกิจกรรม';
                          }
                          return null;
                        },
                        maxLines: 1,
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<EventType>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'ประเภทกิจกรรม',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        items:
                            EventType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      type.icon,
                                      color: type.color,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        type.label,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.surfaceVariant.withOpacity(0.3),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('วันที่'),
                          subtitle: Text(
                            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: _selectDate,
                          dense: true,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.surfaceVariant.withOpacity(
                                  0.3,
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.access_time),
                                title: const Text(
                                  'เริ่ม',
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  _startTime?.format(context) ?? 'ไม่ระบุ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onTap: _selectStartTime,
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.surfaceVariant.withOpacity(
                                  0.3,
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.access_time_filled),
                                title: const Text(
                                  'จบ',
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  _endTime?.format(context) ?? 'ไม่ระบุ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onTap: _selectEndTime,
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'สถานที่',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        maxLines: 1,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'รายละเอียด',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 2,
                        textInputAction: TextInputAction.newline,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'หมายเหตุ',
                          prefixIcon: const Icon(Icons.note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ยกเลิก'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _saveEvent,
                    icon: Icon(
                      widget.existingEvent != null ? Icons.save : Icons.add,
                      size: 18,
                    ),
                    label: Text(
                      widget.existingEvent != null ? 'บันทึก' : 'เพิ่ม',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
