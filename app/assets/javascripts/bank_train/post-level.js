jQuery(document).on('ready page:load', function(){
  // 新增岗位
  jQuery(document).on("submit",".page-posts-form-new .simple_form",function(event){
    var values = $( this ).serializeArray()
    event.preventDefault();
    $.ajax({
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

  // 岗位信息修改 
  jQuery(document).on("click",".btn-group-sm .update-post",function(){
    var post_id = $(this).closest(".update-post").attr("id")
    $.ajax({
      url: "/posts/" + post_id + "/edit",
      method: "get",
      dataType: "html"
    }).success(function(msg) {
      $( "#post-edit" ).html( msg );
    }).error(function(msg){
      console.log(msg)
    });
  });

  jQuery(document).on("submit",".page-posts-form-edit .simple_form",function(event){
    var values = $( this ).serializeArray()
    event.preventDefault();
    $.ajax({
      method: "PATCH",
      url: "/posts/"+values[3].value+"",
      data: $( this ).serializeArray()
    }).success(function( msg ) {
      if(msg.status == 200){
        $(".post_number").removeClass("has-error")
        $(".post_number span").remove();
        $(".post_name").removeClass("has-error")
        $(".post_name span").remove();
        $('#myEditModal').modal('hide');
        location.reload();
      }
    }).error(function(msg){
      if(msg.status == 413){
        if(values[4].value == ""){
          $(".post_number").removeClass("has-error")
          $(".post_number span").remove();
          $(".post_number").addClass("has-error")
          $(".post_number").append("<span class='help-block'>岗位编号不能为空</span>")
        }else{
           $(".post_number").removeClass("has-error")
           $(".post_number span").remove();
        }
        if(values[5].value == ""){
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


// 新增级别
  jQuery(document).on("submit",".page-levels-new .simple_form",function(event){
    var values = $( this ).serializeArray()
    console.log(values)
    event.preventDefault();
    $.ajax({
      method: "POST",
      url: "/levels",
      data: $( this ).serializeArray()
    }).success(function( msg ) {
      if(msg.status == 200){
        $(".level_number").removeClass("has-error")
        $(".level_number span").remove();
        $(".level_name").removeClass("has-error")
        $(".level_name span").remove();
        $('#myModal').modal('hide');
        location.reload();
      }
    }).error(function(msg){
      if(msg.status == 413){
        if(values[2].value == ""){
          $(".level_number").removeClass("has-error")
          $(".level_number span").remove();
          $(".level_number").addClass("has-error")
          $(".level_number").append("<span class='help-block'>级别编号不能为空</span>")
        }else{
           $(".level_number").removeClass("has-error")
           $(".level_number span").remove();
        }
        if(values[3].value == ""){
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
          $(".level_name").addClass("has-error")
          $(".level_name").append("<span class='help-block'>级别名称不能为空</span>")
        }else{
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
        }
      }
    });
  });

  
  // 级别信息修改 
  jQuery(document).on("click",".btn-group-sm .update-level",function(){
    var level_id = $(this).closest(".update-level").attr("id")
    console.log(level_id)
    $.ajax({
      url: "/levels/" + level_id + "/edit",
      method: "get",
      dataType: "html"
    }).success(function(msg) {
      $( "#level-edit" ).html( msg );
    }).error(function(msg){
      console.log(msg)
    });
  });

  jQuery(document).on("submit",".page-levels-edit .simple_form",function(event){
    var values = $( this ).serializeArray()
    event.preventDefault();
    console.log(values)
    console.log(values[3].value)
    $.ajax({
      method: "PATCH",
      url: "/levels/"+values[3].value+"",
      data: $( this ).serializeArray()
    }).success(function( msg ) {
      if(msg.status == 200){
        $(".level_number").removeClass("has-error")
        $(".level_number span").remove();
        $(".level_name").removeClass("has-error")
        $(".level_name span").remove();
        $('#myEditModal').modal('hide');
        location.reload();
      }
    }).error(function(msg){
      if(msg.status == 413){
        if(values[4].value == ""){
          $(".level_number").removeClass("has-error")
          $(".level_number span").remove();
          $(".level_number").addClass("has-error")
          $(".level_number").append("<span class='help-block'>级别编号不能为空</span>")
        }else{
           $(".level_number").removeClass("has-error")
           $(".level_number span").remove();
        }
        if(values[5].value == ""){
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
          $(".level_name").addClass("has-error")
          $(".level_name").append("<span class='help-block'>级别名称不能为空</span>")
        }else{
          $(".level_name").removeClass("has-error")
          $(".level_name span").remove();
        }
      }
    });
  });
});
