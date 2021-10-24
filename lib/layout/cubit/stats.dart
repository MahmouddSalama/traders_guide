abstract class NewsSates{}

class NewsInitialStates extends NewsSates{}

class NewsBottomNaveStates extends NewsSates{}

class NewsGetBusinessSuccessState extends NewsSates{}
class NewsGetBusinessErrorState extends NewsSates{
  final String error;
  NewsGetBusinessErrorState(this.error);
}
class NewsGetBusinessLoadingState extends NewsSates{}

class NewsGetSportsSuccessState extends NewsSates{}
class NewsGetSportsErrorState extends NewsSates{
  final String error;
  NewsGetSportsErrorState(this.error);
}
class NewsGetSportsLoadingState extends NewsSates{}

class NewsGetScienceSuccessState extends NewsSates{}
class NewsGetScienceErrorState extends NewsSates{
  final String error;
  NewsGetScienceErrorState(this.error);
}
class NewsGetScienceLoadingState extends NewsSates{}