<%@page import="domain.admin.dao.AdminDao"%>
<%@page import="oracle.sql.json.OracleJsonArray"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
    <title>사이트 통계 확인하기 페이지</title>
    <%@ include file="../../common/common.jsp" %>
<style>
    .sidebar .nav-link:hover {
        background-color: #444; 
    }
    .btn-danger {
        background-color: #dc3545; 
        border-color: #dc3545; 
    }
</style>
<body>
<%@ include file="/admin/common/login.jsp" %>
<!-- 
	사이트 통계를 낼 때 필요한 데이터
	
	회원 -> 활성화/비활성화 회원 비율
	[ 유저 타입 별 유저 수를 조회하는 메소드 ]
	[ 활성화 회원 수 조회, 비활성화 회원 수 조회 ]
	 사용자/관리자 회원 비율, 이메일 도메인별 회원 분포,
         지역별 회원 분포

도서 -> 카테고리별 도서 분포, 금액별 도서 분포

게시글 -> 게시판별 게시글 비율, 


회원
1. 활성화/ 비활성화 회원 비율
2. 이메일 도메인별 회원 분포

도서 
1. 카테고리별 등록된 도서 분포
2. 금액별 도서 분포

회원 변동 추이
1. 월별 회원 가입자수 ( 매년 해당월 )
2. 연도별 회원 가입자수 ( 근 5년 )

막대 배경색
연한 red : 'rgba(255, 99, 132, 0.2)'
연한 blue : 'rgba(54, 162, 235, 0.2)'
연한 yellow : 'rgba(255, 206, 86, 0.2)'
연한 green : 'rgba(75, 192, 192, 0.2)'
연한 purple : 'rgba(153, 102, 255, 0.2)'
연한 orange : 'rgba(255, 159, 64, 0.2)'

막대 테두리색
연한 red : 'rgba(255, 99, 132, 1)'
연한 blue : 'rgba(54, 162, 235, 1)'
연한 yellow : 'rgba(255, 206, 86, 1)'
연한 green : 'rgba(75, 192, 192, 1)'
연한 purple : 'rgba(153, 102, 255, 1)'
연한 orange : 'rgba(255, 159, 64, 1)'

	기본적인 차트 디자인 
	
	// Bar chart
	new Chart(document.getElementById("bar-chart"), {
	    type: 'bar',
	    data: {
	      labels: ['활성화', '비활성화'],
	      datasets: [
	        {
	          label: "회원상태 (활성화/비활성화)",
	          backgroundColor: ['rgba(54, 162, 235, 0.2)', 'rgba(255, 99, 132, 0.2)'],
	          data: [activatedUserCount, unactivatedUserCount]
	        }
	      ]
	    },
	    options: {
	      legend: { display: true },
	      title: {
	        display: true,
	        text: '사이트 내의 활성화 회원과 비활성화 회원 비교'
	      }
	    }
	});
	
	// Line Chart
	new Chart(document.getElementById("line-chart"), {
		  type: 'line',
		  data: {
		    labels: [1500,1600,1700,1750,1800,1850,1900,1950,1999,2050],
		    datasets: [{ 
		        data: [86,114,106,106,107,111,133,221,783,2478],
		        label: "Africa",
		        borderColor: "#3e95cd",
		        fill: false
		      }, { 
		        data: [282,350,411,502,635,809,947,1402,3700,5267],
		        label: "Asia",
		        borderColor: "#8e5ea2",
		        fill: false
		      }, { 
		        data: [168,170,178,190,203,276,408,547,675,734],
		        label: "Europe",
		        borderColor: "#3cba9f",
		        fill: false
		      }, { 
		        data: [40,20,10,16,24,38,74,167,508,784],
		        label: "Latin America",
		        borderColor: "#e8c3b9",
		        fill: false
		      }, { 
		        data: [6,3,2,2,7,26,82,172,312,433],
		        label: "North America",
		        borderColor: "#c45850",
		        fill: false
		      }
		    ]
		  },
		  options: {
		    title: {
		      display: true,
		      text: 'World population per region (in millions)'
		    }
		  }
		});

	// pie chart
	new Chart(document.getElementById("pie-chart"), {
	    type: 'pie',
	    data: {
	      labels: ["Africa", "Asia", "Europe", "Latin America", "North America"],
	      datasets: [{
	        label: "Population (millions)",
	        backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
	        data: [2478,5267,734,784,433]
	      }]
	    },
	    options: {
	      title: {
	        display: true,
	        text: 'Predicted world population (millions) in 2050'
	      }
	    }
	});
	
	// donut chart
	new Chart(document.getElementById("doughnut-chart"), {
    type: 'doughnut',
    data: {
      labels: ["Africa", "Asia", "Europe", "Latin America", "North America"],
      datasets: [
        {
          label: "Population (millions)",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: [2478,5267,734,784,433]
        }
      ]
    },
    options: {
      title: {
        display: true,
        text: 'Predicted world population (millions) in 2050'
      }
    }
	});
	
	// bar-chart-horizontal
	new Chart(document.getElementById("bar-chart-horizontal"), {
    type: 'horizontalBar',
    data: {
      labels: ["Africa", "Asia", "Europe", "Latin America", "North America"],
      datasets: [
        {
          label: "Population (millions)",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: [2478,5267,734,784,433]
        }
      ]
    },
    options: {
      legend: { display: false },
      title: {
        display: true,
        text: 'Predicted world population (millions) in 2050'
      }
    }});
    
    Chart.defaults.global.defaultFontSize = 20; -- Chart의 전역 변수, 글자 크기 변경
 -->
<div class="d-flex">
<%@ include file="/admin/common/sidebar.jsp" %>
	<div class="container">
		
		<br/>
		<div class="row">
			<div class="col-md-4">
				<canvas id="pie-chart"></canvas>
			</div>
			<div class="col-md-8">
				<canvas id="bar-chart-vertical"></canvas>
			</div>
		</div>
		<br/>
		<div class="row">
			<div class="col-md-4">
				<canvas id="pie-chart-2"></canvas>
			</div>
			<div class="col-md-5">
				<canvas id="bar-chart-horizontal-2"></canvas>
			</div>
		</div>
		<br/>
		<div class="row">
			<div class="col-md-8">
				<canvas id="line-chart-1"></canvas>
			</div>
		</div>
		<br/>
		<div class="row">
			<div class="col-md-8">
				<canvas id="line-chart-2"></canvas>
			</div>
		</div>
	</div>
<% 
	AdminDao adminDao = new AdminDao();

	// 활성화, 비활성화 회원 수
	int activatedUserCount = adminDao.countUserByUserStatus("활성화");
	int unactivatedUserCount = adminDao.countUserByUserStatus("비활성화");
	
	// 이메일, 도메인별 회원 분포 개수
	int naverUser = adminDao.countUserByUserDomain("naver");
	int daumUser = adminDao.countUserByUserDomain("daum");
	int googleUser = adminDao.countUserByUserDomain("gmail");
	int kakaoUser = adminDao.countUserByUserDomain("kakao");
	int otherUser = adminDao.countTotalMembersInBookstore() - (naverUser+daumUser+googleUser+kakaoUser);
	
	// 카테고리별 도서 분포 개수
	int itMobile = adminDao.countBookByBookCategory(1);
	int language = adminDao.countBookByBookCategory(2);
	int selfDevelop = adminDao.countBookByBookCategory(3);
	int naturalScience = adminDao.countBookByBookCategory(4);
	
	// 금액별 도서 분포 개수
	int below10000 = adminDao.countBookByBookPrice(0, 10000);
	int below20000 = adminDao.countBookByBookPrice(10000, 20000);
	int below30000 = adminDao.countBookByBookPrice(20000, 30000);
	int below40000 = adminDao.countBookByBookPrice(30000, 40000);
	int below50000 = adminDao.countBookByBookPrice(40000, 50000);
	int upper50000 = adminDao.countBookByBookPrice(50000, 100000000);
	
	// 연도별 가입한 회원수 [2020, 2021, 2022, 2023, 2024]
	int created2020 = adminDao.countUserByCreatedYear(2020);
	int created2021 = adminDao.countUserByCreatedYear(2021);
	int created2022 = adminDao.countUserByCreatedYear(2022);
	int created2023 = adminDao.countUserByCreatedYear(2023);
	int created2024 = adminDao.countUserByCreatedYear(2024);
	
	// 월별로 가입한 회원수 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	int createdMonth1 = adminDao.countUserByCreatedMonth(1);
	int createdMonth2 = adminDao.countUserByCreatedMonth(2);
	int createdMonth3 = adminDao.countUserByCreatedMonth(3);
	int createdMonth4 = adminDao.countUserByCreatedMonth(4);
	int createdMonth5 = adminDao.countUserByCreatedMonth(5);
	int createdMonth6 = adminDao.countUserByCreatedMonth(6);
	int createdMonth7 = adminDao.countUserByCreatedMonth(7);
	int createdMonth8 = adminDao.countUserByCreatedMonth(8);
	int createdMonth9 = adminDao.countUserByCreatedMonth(9);
	int createdMonth10 = adminDao.countUserByCreatedMonth(10);
	int createdMonth11 = adminDao.countUserByCreatedMonth(11);
	int createdMonth12 = adminDao.countUserByCreatedMonth(12);
%>
</div>
<script>

	//활성화, 비활성화 회원 수
	var activatedUserCount = <%=activatedUserCount %>
	var unactivatedUserCount = <%=unactivatedUserCount %>
	
	// 이메일, 도메인별 회원 분포 개수
	var naverUser = <%=naverUser %>
	var daumUser = <%=daumUser %>
	var googleUser = <%=googleUser %>
	var kakaoUser = <%=kakaoUser %>
	var otherUser = <%=otherUser %>
	
	// 카테고리별 도서 분포 개수
	var itMobile = <%=itMobile %>
	var language = <%=language %>
	var selfDevelop = <%=selfDevelop %>
	var naturalScience = <%=naturalScience %>
	
	// 금액별 도서 분포 개수
	var below10000 = <%=below10000 %>
	var below20000 = <%=below20000 %>
	var below30000 = <%=below30000 %>
	var below40000 = <%=below40000 %>
	var below50000 = <%=below50000 %>
	var upper50000 = <%=upper50000 %>
	
	// 연도별 가입한 회원수 [2020, 2021, 2022, 2023, 2024]
	var created2020 = <%=created2020%>
	var created2021 = <%=created2021%>
	var created2022 = <%=created2022%>
	var created2023 = <%=created2023%>
	var created2024 = <%=created2024%>
	
	// 월별로 가입한 회원수 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	var createdMonth1 = <%=createdMonth1%>
	var createdMonth2 = <%=createdMonth2%>
	var createdMonth3 = <%=createdMonth3%>
	var createdMonth4 = <%=createdMonth4%>
	var createdMonth5 = <%=createdMonth5%>
	var createdMonth6 = <%=createdMonth6%>
	var createdMonth7 = <%=createdMonth7%>
	var createdMonth8 = <%=createdMonth8%>
	var createdMonth9 = <%=createdMonth9%>
	var createdMonth10 = <%=createdMonth10%>
	var createdMonth11 = <%=createdMonth11%>
	var createdMonth12 = <%=createdMonth12%>
	
	Chart.defaults.global.defaultFontSize = 20;
	// Bar chart
	new Chart(document.getElementById("pie-chart"), {
	    type: 'pie',
	    data: {
	      labels: ['Activated', 'UnActivated'],
	      datasets: [
	        {
	          label: "회원상태 (활성화/비활성화)",
	          backgroundColor: ['rgba(54, 162, 235, 0.2)', 'rgba(255, 99, 132, 0.2)'],
	          data: [activatedUserCount, unactivatedUserCount]
	        }
	      ]
	    },
	    options: {
	      legend: { display: true },
	      title: {
	        display: true,
	        text: '사이트 내의 활성화 회원과 비활성화 회원 비교'
	      }
	    }
	});
	
	// bar-chart-horizontal
	new Chart(document.getElementById("bar-chart-vertical"), {
	    type: "bar",
	    data: {
	      labels: ["네이버", "다음", "지메일", "카카오", "기타"],
	      datasets: [
	        {
	          label: "이메일 (네이버/다음/지메일/카카오/기타) ",
	          backgroundColor: ['rgba(255, 99, 132, 0.2)',
					        	'rgba(54, 162, 235, 0.2)',
					        	'rgba(255, 206, 86, 0.2)',
					        	'rgba(75, 192, 192, 0.2)',
					        	'rgba(153, 102, 255, 0.2)'],
	          data: [naverUser, daumUser, googleUser, kakaoUser, otherUser]
	        }
	      ]
	    },
	    options: {
	      legend: { display: true },
	      title: {
	        display: true,
	        text: '사이트 내의 유저별 이메일 도메인 현황'
	      }
	    }
    });
	
	// pie-chart-2
	new Chart(document.getElementById("pie-chart-2"), {
	    type: "pie",
	    data: {
	      labels: ["IT/모바일", "언어/외국어", "자기개발", "자연과학"],
	      datasets: [
	        {
	          label: "카테고리별 도서 분포 (IT-모바일/언어-외국어/자기개발/자연과학) ",
	          backgroundColor: ['rgba(255, 99, 132, 0.2)',
					        	'rgba(54, 162, 235, 0.2)',
					        	'rgba(255, 206, 86, 0.2)',
					        	'rgba(75, 192, 192, 0.2)'],
	          data: [itMobile, language, selfDevelop, naturalScience]
	        }
	      ]
	    },
	    options: {
	      legend: { display: true },
	      title: {
	        display: true,
	        text: '사이트에 등록된 도서의 카테고리별 분포'
	      }
	    }
    });
	
	// bar-chart-horizontal-2
	new Chart(document.getElementById("bar-chart-horizontal-2"), {
	    type: "horizontalBar",
	    data: {
	      labels: ["1만원 이하", "1만원대", "2만원대", "3만원대", "4만원대", "5만원 이상"],
	      datasets: [
	        {
	          label: "금액별 도서분포 (1만원 단위 분류) ",
	          backgroundColor: ['rgba(255, 99, 132, 0.2)',
					        	'rgba(54, 162, 235, 0.2)',
					        	'rgba(255, 206, 86, 0.2)',
					        	'rgba(75, 192, 192, 0.2)',
					        	'rgba(153, 102, 255, 0.2)',
					        	'rgba(255, 159, 64, 0.2)'],
	          data: [below10000, below20000, below30000, below40000, below50000, upper50000]
	        }
	      ]
	    },
	    options: {
	      legend: { display: true },
	      title: {
	        display: true,
	        text: '금액별 도서 분포'
	      }
	    }
    });

	// line-chart-1
	new Chart(document.getElementById("line-chart-1"), {
		  type: 'line',
		  data: {
		    labels: ["2020", "2021", "2022", "2023", "2024"],
		    datasets: [{ 
		        data: [created2020, created2021, created2022, created2023, created2024],
		        label: "최근 5년 연도별 가입자수 추이",
		        backgroundColor: 'rgba(255, 99, 132, 1)',
		        borderColor: "rgba(255, 99, 132, 1)",
		        fill: false
		      }
		    ]
		  },
		  options: {
		    title: {
		      display: true,
		      text: '2020년-2024년 연도별 사이트 가입자수 추이'
		    }
		  }
		});
	
	// line-chart-2
	new Chart(document.getElementById("line-chart-2"), {
		  type: 'line',
		  data: {
		    labels: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
		    datasets: [{ 
		        data: [createdMonth1, createdMonth2, createdMonth3, createdMonth4,
		        	   createdMonth5, createdMonth6, createdMonth7, createdMonth8,
					   createdMonth9, createdMonth10, createdMonth11, createdMonth12
					   ],
		        label: "월별 가입자 추이",
		        borderColor: 'rgba(255, 99, 132, 1)',
		        backgroundColor: 'rgba(255, 99, 132, 1)',
		        fill: false
		      }
		    ]
		  },
		  options: {
		    title: {
		      display: true,
		      text: '월별 가입자 추이'
		    }
		  }
		});
</script>
</body>
</html>