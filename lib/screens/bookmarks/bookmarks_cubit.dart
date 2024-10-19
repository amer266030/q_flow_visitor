import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/company.dart';
import '../../model/enums/company_size.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(BookmarksInitial()) {
    initialLoad();
  }

  List<Company> companies = [];

  initialLoad() {
    companies = List.generate(
      5,
      (index) => Company(
        id: '${index + 1}',
        name: 'ABC Company',
        description:
            'XYZ is a startup company that is specialized in providing tech solutions based on client needs.',
        companySize: CompanySize.oneHundredTo200,
        establishedYear: 2015,
        logoUrl: null,
      ),
    );

    emitUpdate();
  }

  void emitUpdate() => emit(UpdateUIState());
}
