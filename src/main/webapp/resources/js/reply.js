console.log("Reply Module...........");

const replyService = (function() {
	
	function add(reply, callback, error) {
		console.log("add reply.......");
		
		$.ajax({
			method: "post",
			url: "/replies/new",
			data: JSON.stringify(reply),
			contentType: "application/json; charset=UTF-8",
			success: function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error: function(xhr, status, err) {
				if (error) {
					error(err);
				}
			}
		});
	}
	
	function getList(param, callback, error) {
		const bno = param.bno;
		const page = param.page || 1;
		
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json", function(data) {
			if (callback) {
				callback(data.replyCnt, data.list);
			}
		}).fail(function(xhr, status, err) {
			if (error) {
				error(err);
			}
		});
	}
	
	function remove(rno, replyer, callback, error) {
	    $.ajax({
	        type: 'delete',
	        url: '/replies/' + rno,
	        data: JSON.stringify({
	            rno: rno,
	            replyer: replyer
	        }),
	        contentType: "application/json; charset=utf-8",
	        success: function(deleteResult, status, xhr) {
	            if (callback) {
	                callback(deleteResult);
	            }
	        },
	        error: function(xhr, status, er) {
	            if (error) {
	                error(er);
	            }
	        }
	    });
	}
	
	function update(reply, callback, error) {
		console.log("RNO : " + reply.rno);
		
		$.ajax({
			method: "patch",
			url: "/replies/" + reply.rno,
			data: JSON.stringify(reply),
			contentType: "application/json; charset=UTF-8",
			success: function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error: function(xhr, status, err) {
				if (error) {
					error(err);
				}
			}
		});
	}
	
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if (callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if (error) {
				error(err);
			}
		});
	}
	
	function displayTime(timeValue) {
		const today = new Date();
		const gap = today.getTime() - timeValue;
		
		const dataObj = new Date(timeValue);
		let str = "";
		
		if (gap < (1000 * 60 * 60 * 24)) { 
			// 하루가 지나지 않은 경우
			const hh = dataObj.getHours();
			const mi = dataObj.getMinutes();
			const ss = dataObj.getSeconds();
			
			// 15:38:44 의 형식으로 리턴
			return [(hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss].join('');
		} else {
			// 하루가 지난 경우
			const yy = dataObj.getFullYear();
			const mm = dataObj.getMonth() + 1;
			const dd = dataObj.getDate();
			
			// 2018/12/08 형식으로 리턴
			return [yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd].join('');
		}
	}
	
	return {
		add : add,
		getList : getList,
		remove: remove,
		update: update,
		get: get,
		displayTime: displayTime
	};
})();