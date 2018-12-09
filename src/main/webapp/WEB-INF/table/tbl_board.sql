CREATE SEQUENCE SEQ_BOARD;

CREATE TABLE TBL_BOARD 
(
    BNO NUMBER(10, 0),
    TITLE VARCHAR2(200) NOT NULL,
    CONTENT VARCHAR2(2000) NOT NULL,
    WRITER VARCHAR2(50) NOT NULL,
    REGDATE DATE DEFAULT SYSDATE,
    UPDATEDATE DATE DEFAULT SYSDATE
);

ALTER TABLE TBL_BOARD ADD CONSTRAINT PK_BOARD 
PRIMARY KEY(BNO);

INSERT INTO TBL_BOARD (BNO, TITLE, CONTENT, WRITER)
VALUES (SEQ_BOARD.NEXTVAL, '테스트 제목', '테스트 내용', 'user00');

ALTER TABLE TBL_BOARD ADD (REPLYCNT NUMBER DEFAULT 0);

UPDATE TBL_BOARD SET REPLYCNT = (SELECT COUNT(RNO) FROM TBL_REPLY WHERE TBL_REPLY.BNO = TBL_BOARD.BNO);