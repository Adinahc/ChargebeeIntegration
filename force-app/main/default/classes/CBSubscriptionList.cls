public class CBSubscriptionList{
	public cls_list[] listC;
	public class cls_list {
		public CBSubscription.cls_subscription subscription;
	}
	public static CBSubscriptionList parse(String json){
		return (CBSubscriptionList) System.JSON.deserialize(json, CBSubscriptionList.class);
	}
}