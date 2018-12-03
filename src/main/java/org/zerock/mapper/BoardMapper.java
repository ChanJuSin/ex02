package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardVO;

public interface BoardMapper {

	// @Select("SELECT * FROM TBL_BOARD WHERE BNO > 0")
	public List<BoardVO> getList();

	public void insert(BoardVO board);
	
	public void insertSelectKey(BoardVO board);
	
}
