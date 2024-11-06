<%@page import="domain.user.dao.UserDao"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>마이페이지 수정 폼</title>
<%@ include file="../common/common.jsp"%>
<style>
.subContent {
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
</style>
</head>
<body>
	<%@ include file="../common/header.jsp"%>

	<div class="container mt-4">
		<form action="updateUser.jsp" method="post" onsubmit="return checkForm()">
			<table class="table table-bordered">
				<colgroup>
					<col width="15%">
					<col width="35%">
					<col width="15%">
					<col width="35%">
				</colgroup>
<%
	UserDao userDao = new UserDao();
	User user = userDao.getUserByUserNo(USERNO);
%>
				<tbody>
					<tr>
						<th class="table-light text-center align-middle">아이디</th>
						<td class="align-middle">
						<input type="hidden" id="userNo" name="userNo" value="<%=USERNO %>">
						<input type="text" class="form-control" name="id" value="<%=user.getId() +"("+ user.getType() %>)" readonly></td>
						<th class="table-light text-center align-middle">이메일</th>
						<td class="align-middle">
						<input type="email" class="form-control" name="email" value="<%=user.getEmail() %>" readonly></td>
					</tr>
					<tr>
						<th class="table-light text-center align-middle">닉네임</th>
						<td class="align-middle">
						<input type="text" class="form-control" name="nickname" value="<%=user.getNickname() %>"></td>
						<th class="table-light text-center align-middle">핸드폰 번호</th>
						<td class="align-middle">
						<input type="tel" class="form-control" name="phone" value="<%=user.getPhone() %>">
						<p id="phoneMsg"></p></td>
					</tr>
					<tr>
						<th class="table-light text-center align-middle">가입 날짜</th>
						<td class="align-middle">
						<input type="text" class="form-control" value="<%=user.getCreatedDate() %>" readonly></td>
						<th class="table-light text-center align-middle">내 정보 최근 수정
							날짜</th>
<%
	if (user.getUpdatedDate() != null) {
%>
						<td class="align-middle"><input type="text" class="form-control" value="<%=user.getUpdatedDate() %>" readonly></td>
<%
	} else {
%>
						<td class="align-middle"><input type="text" class="form-control" value="-" readonly></td>
<%
	}
%>
					</tr>
					<tr>
                        <th class="table-light text-center align-middle">주소</th>
                        <td colspan="3" class="align-middle">
                            <!-- 맨 처음에 나올 기존 주소 -->
                            <div id="savedAddress">
                                <input type="text" class="form-control mb-2" name="address" value="<%=user.getAddress() %>" readonly>
                                <button type="button" id="addressModifyButton" class="btn btn-secondary btn-sm" onclick="modifyAddress();">주소 수정</button>
                            </div>
                            
                            <!-- 수정 버튼을 누르면 등장할 다음 api 주소 -->
                            <div id="newAddress" style="display: none;">
                                <div class="input-group mb-2">
                                    <input type="text" id="postcode" name="addr1" class="form-control" placeholder="우편번호" readonly>
                                    <div class="input-group-append">
                                        <button type="button" class="btn btn-secondary" onclick="daumPostcode();">우편번호 찾기</button>
                                    </div>
                                </div>
                                <input type="text" id="roadAddress" name="addr2" class="form-control mb-2" placeholder="도로명주소" readonly>
                                <input type="hidden" id="jibunAddress" placeholder="지번주소">
                                <span id="guide" style="color:#999;display:none"></span>
                                <input type="text" id="detailAddress" name="addr3" class="form-control mb-2" placeholder="상세주소">
                                <input type="hidden" id="extraAddress" placeholder="참고항목">
                                <input type="hidden" id="engAddress" placeholder="영문주소">
                            </div>
                        </td>
                    </tr>
				</tbody>
			</table>
			<div class="text-center mt-3 mb-5">
				<button type="submit" class="btn btn-primary btn-lg">수정</button>
			</div>
		</form>
	</div>
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script type="text/javascript">
    const REG_PHONE = /^(01[016789]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
    
    function checkForm(){
    	let nicknameValue = document.querySelector("[name=nickname]").value;
    	let phoneValue = document.querySelector("[name=phone]").value;
    	let addressValue = document.querySelector("[name=address]").value;
		if (nicknameValue.trim() === ""
			|| phoneValue.trim() === ""
			|| addressValue.trim() === "") {
			alert('작성하지 않은 칸이 존재합니다.');
			return false;
		}
		
		if (!REG_PHONE.test(phoneValue)) {
			alert('알맞은 핸드폰 번호 양식이 아닙니다.');
			return false;
		}
		
		if (nicknameValue.length < 2) {
			alert('닉네임은 최소 2글자 이상입니다.');
			return false;
		}
		
		if (!checkSameNickname()) {
			alert('중복된 닉네임입니다.');
			return false;
		}
		return true;
    }
    
	// 수정 버튼 누를 시 닉네임 유효성
	function checkSameNickname() {
		let result = false;
		let nicknameValue = document.querySelector("[name=nickname]").value;
		// ajax
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let data = xhr.responseText.trim();
                if (data === 'none') {
                	result = true;
                } else if (data === 'exist') {
                	result = false;
                }
            }
        };
       
        xhr.open("GET", "mypage-nicknameCheck.jsp?nickname=" + nicknameValue.trim() + "&userNo=" + <%=USERNO %>, false);
        xhr.send();
        return result;
	}
    
    function daumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var roadAddr = data.roadAddress;
                var extraRoadAddr = '';

                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("roadAddress").value = roadAddr;
                document.getElementById("jibunAddress").value = data.jibunAddress;
                document.getElementById("engAddress").value = data.addressEnglish;
                       
                if(roadAddr !== ''){
                    document.getElementById("extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
    
    // 처음엔 기존에 주소를 보여주고 수정 버튼을 누르면 기존에 보여주는 주소와 수정 버튼을 없애고 회원가입의 주소 api등장
    function modifyAddress(){
    	document.getElementById('savedAddress').style.display = "none";
    	document.getElementById('newAddress').style.display = "";
    }
    </script>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>