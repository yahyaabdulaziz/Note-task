import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({Key? key}) : super(key: key);

  @override
  State<NewTaskSheet> createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends State<NewTaskSheet> {
  String selectedPriority = '';
  List<String> categories = ['Work', 'Personal'];
  List<String> selectedCategories = [];

  final TextEditingController _taskNameController = TextEditingController();

  // Date and time variables
  DateTime? startDateTime;
  DateTime? endDateTime;

  // Format for displaying date and time
  final DateFormat _dateTimeFormat = DateFormat('MMM d, yyyy - h:mm a');

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  // Show date time picker
  Future<void> _selectDateTime(bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          if (isStart) {
            startDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          } else {
            endDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          }
        });
      }
    }
  }

  // Add new category
  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCategory = '';
        return AlertDialog(
          title: Text('Add New Category', style: TextStyle(fontSize: 18.sp)),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              hintStyle: TextStyle(fontSize: 14.sp),
            ),
            style: TextStyle(fontSize: 14.sp),
            onChanged: (value) {
              newCategory = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
            ),
            TextButton(
              onPressed: () {
                if (newCategory.trim().isNotEmpty) {
                  setState(() {
                    categories.add(newCategory);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Task',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24.h),
          _buildTextField('Task name', _taskNameController),
          SizedBox(height: 16.h),
          _buildTimeField('Start', startDateTime, () => _selectDateTime(true)),
          SizedBox(height: 12.h),
          _buildTimeField('End', endDateTime, () => _selectDateTime(false)),
          SizedBox(height: 24.h),
          Text(
            'Priority',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          _buildPrioritySelection(),
          SizedBox(height: 24.h),
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          _buildCategoryChips(),
          SizedBox(height: 24.h),
          _buildButtons(),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4B8BF5)),
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, DateTime? dateTime, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.access_time, size: 16.r, color: Colors.grey[600]),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            dateTime != null ? _dateTimeFormat.format(dateTime) : 'Select time',
            style: TextStyle(
              fontSize: 14.sp,
              color: dateTime != null ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelection() {
    return Row(
      children: [
        _buildPriorityButton('Low', Colors.green),
        SizedBox(width: 12.w),
        _buildPriorityButton('Med', Colors.amber),
        SizedBox(width: 12.w),
        _buildPriorityButton('High', Colors.red),
      ],
    );
  }

  Widget _buildPriorityButton(String label, Color color) {
    bool isSelected = selectedPriority == label;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedPriority = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color.withAlpha(2) : Colors.grey[100],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ...categories.map((category) => _buildCategoryChip(
              category,
              _getCategoryColor(category),
              selectedCategories.contains(category),
            )),
        GestureDetector(
          onTap: _addNewCategory,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(Icons.add, size: 20.r, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    if (category == 'Work') return Colors.blue[100]!;
    if (category == 'Personal') return Colors.purple[100]!;

    // Generate color based on the category name for new categories
    final int hashCode = category.hashCode;
    final List<Color> predefinedColors = [
      Colors.green[100]!,
      Colors.orange[100]!,
      Colors.red[100]!,
      Colors.teal[100]!,
      Colors.amber[100]!,
      Colors.pink[100]!,
    ];

    return predefinedColors[hashCode % predefinedColors.length];
  }

  Widget _buildCategoryChip(String label, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleCategory(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withAlpha(5),
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected
              ? Border.all(color: color.withAlpha(7), width: 2.r)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B8BF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Create Task',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
