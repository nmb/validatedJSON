function deleteObject(uuid, path) {
  var url = path + uuid;
  if(confirm("Are you sure you want to delete?")){
  fetch(url,
      {
        method: 'delete',
        credentials: 'same-origin'
      }).then(function(response){
    $("#"+uuid).remove();
  }, function(error){
        alert(error);
  });
  }
};

