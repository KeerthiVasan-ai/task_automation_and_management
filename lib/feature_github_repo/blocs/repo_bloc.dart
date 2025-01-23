import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_automation_and_management_system/feature_github_repo/blocs/repo_event.dart';
import 'package:task_automation_and_management_system/feature_github_repo/blocs/repo_state.dart';
import 'package:http/http.dart' as http;

import '../../db/db_helper.dart';
import '../models/repository.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  RepositoryBloc() : super(RepositoryLoading()) {
    on<CheckAndFetchRepositories>(_onCheckAndFetchRepositories);
  }

  Future<void> _onCheckAndFetchRepositories(
      CheckAndFetchRepositories event, Emitter<RepositoryState> emit) async {
    emit(RepositoryLoading());
    final db = DBHelper.instance;
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final repositories = await _fetchRepositoriesFromAPI();
        for (var repo in repositories) {
          await db.insertRepository(repo);
        }
        emit(RepositoryLoaded(repositories));
      } catch (e) {
        final localData = await db.getRepositories();
        if (localData.isNotEmpty) {
          emit(RepositoryLoaded(localData));
        } else {
          emit(RepositoryError(
              'Failed to load repositories. Please try again.'));
        }
      }
    } else {
      final localData = await db.getRepositories();
      if (localData.isNotEmpty) {
        emit(RepositoryLoaded(localData));
      } else {
        emit(RepositoryError('No data found. Please turn on the internet.'));
      }
    }
  }

  Future<List<Repository>> _fetchRepositoriesFromAPI() async {



    final response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?q=created:>2024-12-22&sort=stars&order=desc'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      return items.map((repo) {
        return Repository(
          id: repo['id'].toString(),
          name: repo['name'],
          description: repo['description'] ?? '',
          stars: repo['stargazers_count'],
          ownerUsername: repo['owner']['login'],
          ownerAvatarUrl: repo['owner']['avatar_url'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
