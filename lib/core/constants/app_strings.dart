class AppStrings {
  AppStrings._();
  // Routine It: Align Daily Habits
  static const String appName = "Routine It";
  static const String quote = "Align Daily Habits";
  // themes
  static const String themeLight = "Light Mode";
  static const String themeDark = "Dark Mode";
  static const String themeSystem = "System Default";
  static const String themeMidnightOcean = "Midnight Ocean";
  // in app
  static const String home = "Home";
  static const String task = "Task";
  static const String analytics = "Analytics";
  static const String category = "Category";
  static const String addCategory = "Add Category";
  static const String categoryName = "Category Name";
  static const String categoryNameIsRequired = "Category name is required";
  static const String categoryNameAlreadyExists = "Category name already exists";
  static const String emoji = "Emoji";
  static const String color = "Color";
  static const String basicInformation = "Basic Information";
  static const String appearance = "Appearance";
  static const String updateCategory = "Update Category";
  static const String createCategory = "Create Category";
  static const String deleteCategory = "Delete Category";
  static const String pleaseWait = "Please wait...";
  static const String discardChanges = "Discard Changes?";
  static const String youHaveUnsavedChanges = "You have unsaved changes. Are you sure you want to discard them?";
  static const String discard = "Discard";
  static const String stay = "Stay";
  static const String failedToFetchCategories = "Failed to fetch categories";
  static const String successfullyCategoryCreated = "Category created successfully";
  static const String successfullyCategoryUpdated = "Category updated successfully";
  static const String failedToSaveCategory = "Failed to save category";
  static const String categoryDeleted = "Category deleted";
  static const String deleteCategoryConfirmation = "Delete Category?";
  static const String deleteCategoryWarning = "Are you sure you want to delete this category? All associated tasks and their complete status history will also be permanently deleted. This action cannot be undone.";
  static const String delete = "Delete";
  static const String cancel = "Cancel";
  static const String failedToDeleteCategory = "Failed to delete category";
  static const String max255 = "max 255";

  // Splash Screen
  static const String splashQuote = "Yesterday is history.\nTomorrow is a mystery.\nToday is a gift, that's why it's called the present.";
  static const String stopAlarm = "STOP ALARM";

  // Onboarding
  static const String onboardingTitle1 = "Welcome to Routine It";
  static const String onboardingDesc1 = "Organize your life and build lasting habits with ease.";
  static const String onboardingTitle2 = "Track Your Progress";
  static const String onboardingDesc2 = "See your daily routines and stay motivated every day.";
  static const String onboardingTitle3 = "Stay Notified";
  static const String onboardingDesc3 = "Get timely alerts for your tasks so you never miss a beat.";
  static const String skip = "Skip";
  static const String start = "Start";
  static const String next = "Next";

  // Permissions Screen
  static const String appPermissions = "App Permissions";
  static const String permissionNotifDesc = "Allow notifications to get timely alerts for your routines and habits.";
  static const String precisionAlarms = "Precision Alarms";
  static const String permissionExactAlarmDesc = "Exact alarm permission ensures your reminders fire at the perfect moment, even when your phone is resting.";
  static const String fullScreenAlerts = "Full Screen Alerts";
  static const String permissionSystemAlertDesc = "This allows us to show the alarm screen on top of other apps so you never miss a task.";
  static const String batteryPerformance = "Battery Performance";
  static const String permissionBatteryDesc = "Exempting Routine It from battery optimization ensures that your alarms are never delayed by the system battery saver.";
  static const String backgroundReliability = "Background Reliability";
  static const String permissionAutoStartDesc = "Enable Auto-Start to ensure your routines work reliably in the background.";
  static const String go = "GO";
  static const String granted = "Granted";
  static const String pending = "Pending";

  // Settings Screen
  static const String settings = "Settings";
  static const String preferences = "Preferences";
  static const String appTheme = "App Theme";
  static const String timeFormat = "Time Format";
  static const String dateFormat = "Date Format";
  static const String systemAndPermissions = "System & Permissions";
  static const String managePermissionsSubtitle = "Manage system permissions for alarms and notifications";
  static const String dataManagement = "Data Management";
  static const String exportDataJson = "Export Data (JSON)";
  static const String exportDataSubtitle = "Save your categories, tasks, and progress.";
  static const String importDataJson = "Import Data (JSON)";
  static const String importDataSubtitle = "Restore from a previous backup";
  static const String importBackup = "Import Backup";
  static const String importBackupWarning = "Select a previously saved JSON backup file. This will overwrite your current categories, tasks, and progress.";
  static const String errorSelectedFileEmpty = "The selected file is empty.";
  static const String selectFile = "Select File";
  static String importErrorMsg(String e) => "An error occurred while reading the file: $e";
  static const String clearAllData = "Clear All Data";
  static const String clearAllDataSubtitle = "Delete all tasks, settings, alarms, and notifications";
  static const String clearAllDataWarningTitle = "Clear All Data?";
  static const String clearAllDataWarningMessage = "Are you sure you want to delete all your data? This will permanently remove all categories, tasks, history, custom preferences, active alarms, and notifications. We recommend exporting your data before deleting if you want to keep a backup. This action cannot be undone.";
  static const String clear = "Clear";

  // Category Page
  static const String searchCategory = "Search Category";
  static const String noCategoriesYet = "No categories yet. Click + to add one!";
  static const String noCategoriesMatchSearch = "No categories match search.";
  static const String taskSingular = "task";
  static const String taskPlural = "tasks";

  // Home Screen & Home View
  static const String helpAndFeedback = "Help & Feedback";
  static const String logout = "Logout";
  static const String bubbleView = "Bubble View";
  static const String upcomingTasks = "Upcoming Tasks";
  static const String completed = "Completed";
  static const String today = "Today";
  static const String noTasksFreshStart = "No tasks for this day.\nTime for a fresh start?";
  static String tasksProgress(int completed, int total) => "$completed/$total Tasks";

  // Task Page & Task Form Page
  static const String searchTasks = "Search Tasks";
  static const String priority = "Priority";
  static const String noTasksYet = "No tasks yet. Click + to add one!";
  static const String loadingTask = "Loading Task...";
  static const String taskDetails = "Task Details";
  static const String scheduleAndTiming = "Schedule & Timing";
  static const String previewTask = "Preview Task";
  static const String updateTask = "Update Task";
  static const String createTask = "Create Task";
  static const String deleteTask = "Delete Task";
  static const String deleteTaskConfirmation = "Delete Task?";
  static const String deleteTaskWarning = "Are you sure you want to delete this task? All associated status history will be permanently deleted. This action cannot be undone.";
  static const String previewMandatoryWarning = "Fill all mandatory fields to preview the task";
  static const String previewNoOccurrenceWarning = "Task does not occur in the next 90 days";
  static const String schedulePreview = "Schedule Preview";
  static const String totalTasksLabel = "Total tasks: ";
  static const String includingCurrentTask = " (including current task)";
  static String showingTasksFor(String date) => "Showing tasks for $date";

  // Analytics Page
  static const String day = "Day";
  static const String month = "Month";
  static const String dayBasedInsights = "Day Based Insights";
  static const String noTasksForDay = "No tasks for this day";
  static const String tasksCompleted = "Tasks Completed";
  static const String totalTasks = "Total Tasks";
  static const String perfect = "Perfect";
  static const String avg = "Avg";
  static const String completedTasks = "Completed Tasks";
  static const String noTasksFound = "No tasks found";
  static const String selectMonth = "Select Month";
  static const String now = "Now";
  static const String week = "Week";
  static const String year = "Year";
  static const String monthlyOverview = "Monthly Overview";
  static const String tasksOverview = "Tasks Overview";
  static String currentMonthLabel(String name) => "Current ($name)";
  static String previousMonthLabel(String name) => "Previous ($name)";
  static String nextMonthLabel(String name) => "Next ($name)";
  static String totalTasksCount(int count) => "Total Tasks ($count)";
  static String completedTasksSummary(int completed, int total) => "Completed $completed of $total total tasks scheduled.";
  static String daysCountLabel(int passed, int total) => "$passed / $total days";
  static String lineChartTooltip(String date, String name, int val) => "$date\n$name: $val";
  static String lineChartSubTooltip(String name, int val) => "$name: $val";
  static String monthSummaryHeader(String month) => "$month Summary";
  static String taskStatisticsHeader(int count) => "Task Statistics ($count)";
  static String countTimes(String count) => " (x$count)";
  static String tasksRatio(int completed, int total) => "$completed/$total";

  // Task Timeline Widget
  static const String filterByTask = "Filter by Task";
  static const String filterByCategory = "Filter by Category";
  static const String noCategory = "No Category";
  static const String timelineView = "Timeline View";
  static const String timelineGuide = "Timeline Guide";
  static const String scrollToCurrentTime = "Scroll to current time";
  static const String nextTask = "Next Task";
  static const String previousTask = "Previous Task";
  static const String noTasksAvailableForDate = "No tasks available for this date.";
  static const String updateTaskTimeConfirmation = "Update Task Time?";
  static const String previous = "Previous";
  static const String updatingTo = "Updating To";
  static const String updateTaskTimeWarning = "Are you sure you want to update this task's time?";
  static const String currentDayTasks = "Current Day Tasks";
  static const String currentlySelectedTask = "Currently Selected Task";
  static const String previousDayPending = "Previous Day Pending";
  static const String currentDayPending = "Current Day Pending";
  static const String currentDayCompleted = "Current Day Completed";
  static const String previousDayCompleted = "Previous Day Completed";
  static const String rescheduleEditTasks = "Reschedule / Edit Tasks";
  static const String rescheduleTasksGuide = "Long press and drag a task horizontally along the timeline to reschedule it.";
  static const String gotIt = "Got it";
  static const String confirm = "Confirm";

  // OTP Dialog
  static const String otpTitle = "Verify Code";
  static const String otpSubtitle = "Enter the 6-digit code sent to your email";
  static const String otpBtn = "Verify & Proceed";
  static const String resendOtpText = "Didn't receive code? ";
  static const String resendOtpAction = "Resend";
}