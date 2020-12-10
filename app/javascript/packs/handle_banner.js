function ajax_handle_banner(url,data)
{
  var token = $('meta[name="csrf-token"]').attr('content')
  $.ajax({
    type: 'PATCH',
    url: url+data.id,
    data: {
      id: data.id,
      type: data.type
    },
    dataType: 'JSON',
    headers: {
      "x-csrf-token": token,
    },
  }).done(function (data) {
    Swal.fire(
      'Xử lý tài khoản thành công',
      '',
      'success'
    ).then((result) => {
      if (result.isConfirmed) {
        location.reload();
      }
    })
  }).fail(function (data) {
    Swal.fire(
      'Xử lý tài khoản thất bại',
      '',
      'error'
    ).then((result) => {
      if (result.isConfirmed) {
        location.reload();
      }
    })
  });
}
$(document).ready(function() {
  $(document).on('click','.banner-account',function(){
    Swal.fire({
      title: 'Xác nhận xử lý tài khoản',
      icon: 'info',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: 'Hủy',
      confirmButtonText: 'Xử lý'
    }).then((result) => {
      if (result.isConfirmed) {
        ajax_handle_banner("/admin/users/",$(this).data())
      }
    })
  });
});
