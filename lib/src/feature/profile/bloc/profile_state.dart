abstract interface class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {}

class GetAllAuthorsState extends ProfileState {
  final List<String> authors;
  GetAllAuthorsState(this.authors);

  List<Object?> get props => [authors];
}
