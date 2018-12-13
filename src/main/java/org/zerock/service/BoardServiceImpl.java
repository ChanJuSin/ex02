package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.Setter;

/*
 * 	@AllArgsConstructor
 * 	 --- 해당 클래스의 인스턴스 변수들을 생성자의 파라미터로 받는다.
 *   --- 아래 클래스의 경우 BoardServiceImpl 인스턴스를 생성하면서 BoardMapper 인터페이스의 구현체를 주입 받는다.
 */
@Service
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = { @Autowired })
	private BoardMapper mapper;
	
	@Setter(onMethod_ = { @Autowired })
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		mapper.insertSelectKey(board);
		
		if (board.getAttachVOList() == null || board.getAttachVOList().size() <= 0) {
			return;
		}
		
		board.getAttachVOList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotalCount(cri);
	}

}
