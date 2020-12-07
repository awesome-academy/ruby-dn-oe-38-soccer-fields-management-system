function handle_booking(date,id_timecost,time){
  var token = $('meta[name="csrf-token"]').attr('content')
  $.ajax({
    type: 'POST',
    url: '/user/bookings',
    data: {
      date: date,
      id_timecost: id_timecost,
      time: time
    },
    headers: {
      "x-csrf-token": token,
    },
    dataType: 'JSON',
    success: function (response) {
      if(response.success)
          var icon = 'success'
      else
        var icon = 'error'
      Swal.fire(
        response.title,
        response.content,
        icon
      ).then((result) => {
        if (result.isConfirmed) {
          location.reload();
        }
      })
    }
  });
}

$(document).on('click','.booked_yard',function(){
  Swal.fire({
    icon: 'error',
    title: 'Hmmm...',
    text: 'Sân này đã được đặt!',
  })
});

$(document).on('click','.btn-login-booking',function(){
  Swal.fire({
    title: 'Bạn vui lòng đăng nhập trước khi đặt sân',
    showCancelButton: true,
    confirmButtonText: 'Đăng nhập',
  }).then((result) => {
    if (result.isConfirmed) {
      window.location='http://localhost:3000/login'
    }
  })
});

$(document).on('click','.booking_yard',function(){
  var location_name = $(this).data('location')
  var code = $(this).data('code')
  var time = $(this).data('time')
  var type = $(this).data('type')
  var cost = $(this).data('cost').split(".")[0]
  var date = $('#date').val()
  var timecost_id = $(this).data('id')
  Swal.fire({
    title: 'Xác nhận thông tin đặt sân',
    html:
      `<b>Tên sân: </b>${location_name}<br>
      <b>Ngày: </b>${date}<br>
      <b>Thời gian: </b>${time}<br>
      <b>Loại sân: </b>${type}<br>
      <b>Mã sân: </b>${code}<br>
      <b>Giá tiền: </b>${cost}<br>`,
    icon: 'info',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    cancelButtonText: 'Hủy',
    confirmButtonText: 'Đặt sân'
  }).then((result) => {
    if (result.isConfirmed) {
      handle_booking(date,timecost_id,time)
    }
  })
});
