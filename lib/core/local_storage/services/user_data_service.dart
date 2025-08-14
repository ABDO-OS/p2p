// core/services/user_data/user_data_service.dart
import 'user_data_loader.dart';
import 'user_data_saver.dart';
import 'user_data_validator.dart';
import 'user_data_stats.dart';
import 'user_data_utils.dart';
import 'selected_banks_service.dart';

class UserDataService {
  // Loader methods
  static final loadLastUserData = UserDataLoader.loadLastUserData;
  static final searchUsers = UserDataLoader.searchUsers;
  static final importUsers = UserDataLoader.importUsers;

  // Saver methods
  static final saveUserData = UserDataSaver.saveUserData;
  static final updateUser = UserDataSaver.updateUser;
  static final deleteUser = UserDataSaver.deleteUser;

  // Validator method
  static final validateUserData = UserDataValidator.validateUserData;

  // Stats methods
  static final getUserStats = UserDataStats.getUserStats;
  static final getAdvancedUserStats = UserDataStats.getAdvancedUserStats;
  static final exportUsers = UserDataStats.exportUsers;

  // Utils methods
  static final clearControllers = UserDataUtils.clearControllers;
  static final populateControllers = UserDataUtils.populateControllers;
  static final createUserDataMap = UserDataUtils.createUserDataMap;

  // Bank selection methods
  static final saveSelectedBanks = SelectedBanksService.saveSelectedBanks;
  static final getSelectedBanks = SelectedBanksService.getSelectedBanks;
  static final saveLastBankSelection =
      SelectedBanksService.saveLastBankSelection;
  static final getLastBankSelection = SelectedBanksService.getLastBankSelection;
  static final hasSelectedBanks = SelectedBanksService.hasSelectedBanks;
  static final clearSelectedBanks = SelectedBanksService.clearSelectedBanks;
  static final addBankToSelection = SelectedBanksService.addBankToSelection;
  static final removeBankFromSelection =
      SelectedBanksService.removeBankFromSelection;
}
