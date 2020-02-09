<?php 
session_start();
?>
<?php 
$pass = "29031996";
if (isset($_POST['pass'])) {
	$mk = $_POST['pass'];
	if ($mk === $pass) {
		 $_SESSION['username'] = $mk;
		 echo "<script language='javascript'> location.href='index.php';</script>";
	}else{
		 echo "<script language='javascript'>alert('Sai Pass rồi E ơi:)) ');";
                echo "location.href='login.php';</script>";
	}

}
?>
<!DOCTYPE html>
<html>
<head>
	<title>Xác nhận là Hân Heo cái đã!</title>
	<meta property="og:url"                content="http://autocmt.net/hanheo" />
	<meta property="og:type"               content="Hân Heo :) 🥰" />
	<meta property="og:title"              content="Thư Gửi Hân Heo 🥰" />
	<meta property="og:description"        content="cố hack mà đọc nhửng bí mật nhé :D" />
	<meta property="og:image"              content="https://i.imgur.com/TZmbj5z.jpg" />
	<!-- Latest compiled and minified CSS & JS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<script src="//code.jquery.com/jquery.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
</head>
<body>
	<div class="container-fluid">
		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div class="panel panel-info">
				<div class="panel-heading">
					<h3 class="panel-title">Xác nhận là Hân Heo cái đã!</h3>
				</div>
				<div class="panel-body">
					<form action="" method="POST" role="form">
						
					
						<div class="form-group">
							<label for="">Mật Khẩu</label>
							<input type="password" class="form-control" name="pass" id="" placeholder="Nhập Mật Khẩu Cái Đã">
						</div>
					
						
					
						<button type="submit" class="btn btn-primary">OK</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>