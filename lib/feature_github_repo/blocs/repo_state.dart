import '../models/repository.dart';

class RepositoryState {}

class RepositoryLoading extends RepositoryState {}

class RepositoryLoaded extends RepositoryState {
  final List<Repository> repositories;

  RepositoryLoaded(this.repositories);
}

class RepositoryError extends RepositoryState {
  final String message;

  RepositoryError(this.message);
}
