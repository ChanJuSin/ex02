package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.service.BoardService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

	@Setter(onMethod_ = { @Autowired })
	private BoardService service;
	
	@Setter(onMethod_ = { @Autowired })
	private BoardMapper mapper; 
	
	public void testGetList() {
		service.getList(new Criteria(2, 10)).forEach(board -> log.info(board));
	}

	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글 select key");
		board.setContent("새로 작성하는 내용 select key");
		board.setWriter("newbie");
		
		mapper.insertSelectKey(board);
		
		log.info(board);
	}
	
	public void testRead() {
		BoardVO board = mapper.read(1L);
		log.info(board);
	}
	
	public void testDelete() {
		log.info("DELETE COUNT : " + mapper.delete(1L));
	}

	public void testUpdate() {
		BoardVO board = new BoardVO();
		board.setBno(5L);
		board.setTitle("수정된 제목");
		board.setContent("수정된 내용");
		board.setWriter("user00");
		
		int count = mapper.update(board);
		log.info("UPDATE COUNT : " + count);
	}

	public void testPaging() {
		Criteria cri = new Criteria();
		cri.setAmount(10);
		cri.setPageNum(3);
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board));
	}
	
	public void testSearch() {
		Criteria cri = new Criteria();
		cri.setType("TC");
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		
		list.forEach(board -> log.info(board));
	}
	
	@Test
	public void testSearchCount() {
		Criteria cri = new Criteria();
		cri.setType("TC");
		cri.setKeyword("테스트");
		
		int count = mapper.getTotalCount(cri);
		System.out.println(count);
	}
	
}
