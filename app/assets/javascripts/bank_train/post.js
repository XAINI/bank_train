$(document).on('ready page:load', function(){
  $(".page-posts-new .page-posts-form-new .simple_form").on("submit",function(event){
    var values = $( this ).serializeArray()
    console.log(values)
    console.log(values[3].value)
    event.preventDefault();
    var request = $.ajax({
      method: "POST",
      url: "/posts",
      data: $( this ).serializeArray()
    }).success(function( msg ) {
      if(msg.status == 200){
        $(".post_number").removeClass("has-error")
        $(".post_number span").remove();
        $(".post_name").removeClass("has-error")
        $(".post_name span").remove();
        $('#myModal').modal('hide');
        location.reload();
      }
    }).error(function(msg){
      if(msg.status == 413){
        if(values[2].value == ""){
          $(".post_number").removeClass("has-error")
          $(".post_number span").remove();
          $(".post_number").addClass("has-error")
          $(".post_number").append("<span class='help-block'>岗位编号不能为空</span>")
        }else{
           $(".post_number").removeClass("has-error")
           $(".post_number span").remove();
        }
        if(values[3].value == ""){
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
          $(".post_name").addClass("has-error")
          $(".post_name").append("<span class='help-block'>岗位名不能为空</span>")
        }else{
          $(".post_name").removeClass("has-error")
          $(".post_name span").remove();
        }
      }
    });
  });
});
