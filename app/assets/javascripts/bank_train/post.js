$(document).ready(function(){
  $(".page-posts-new .page-posts-form-new .simple_form").on("submit",function(event){
    event.preventDefault();
    var request = $.ajax({
      method: "POST",
      url: "/posts",
      data: $( this ).serializeArray()
    }).success(function( msg ) {
      if(msg.status == 200){
        $('#myModal').modal('hide');
        location.reload();
      }
    }).error(function(msg){
      if(msg.status == 413){
        msg.responseJSON.name
        $(".post_number").addClass("has-error")
        $(".post_number").append("<span class='help-block'>岗位编号不能为空</span>")
        $(".post_name").addClass("has-error")
        $(".post_name").append("<span class='help-block'>岗位名不能为空</span>")
      }
    });
  });
});
