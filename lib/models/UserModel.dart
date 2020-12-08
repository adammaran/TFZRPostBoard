class UserModel {
  String uid;
  String email;
  String userType;
  String username;

  UserModel(String uid, String email, String userType, String username) {
    this.uid = uid;
    this.email = email;
    this.userType = userType;
    this.username = username;
  }

  String getUid(){
    return this.uid;
  }

  void setUid(String uid){
    this.uid = uid;
  }

  String getEmail(){
    return this.email;
  }

  void setEmail(String email){
    this.email = email;
  }

  String getUserType(){
    return this.userType;
  }

  void setUserType(String userType){
    this.userType = userType;
  }

  String getUsername(){
    return this.username;
  }

  void setUsername(String username){
    this.username = username;
  }
}
