



class InviteToOrganisationDynamicState implements InviteToOrganisationOutputState {

  String email;

  setEmail(String? e)=>email = e ?? '';

  InviteToOrganisationDynamicState({this.email = ''});

}


abstract class InviteToOrganisationOutputState  {

  String get email;
}