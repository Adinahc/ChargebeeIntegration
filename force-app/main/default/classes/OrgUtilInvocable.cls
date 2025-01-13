/**
* @author: Solved by Software, Co
*/

global class OrgUtilInvocable {
    @InvocableMethod(Label='Get Org Base Url') 
    public static List<String> OrgUtilInvocable() {
        List<String> urls = new List<String>();
        urls.add(URL.getOrgDomainURL().toExternalForm());
        return urls;
    }
}