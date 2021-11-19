create user tester2 identified by 1234;
grant connect,resource to tester2;
commit; -- system 계정에서!

-- + 창 누르고 tester2 , 1234 하고 테스트 이후 성공 뜨면 그 계정으로 접속해서 작업하기

create table board (
    num  number(7,0) not null, -- 최대 정수자리 7, 소수점자리 0개라는 의미
    writer varchar2(12) not null,
    email varchar2(30) not null,
    subject varchar2(50) not null,
    pass varchar2(10) not null,
    readcount number(5,0) default 0 not null,
    ref number(5,0) default 0 not null,
    step number(3,0) default 0 not null,
    depth number(3,0) default 0 not null,
    regdate timestamp default sysdate not null,
    content varchar2(4000) not null,
    ip varchar2(20) not null,
    constraint board_pk primary key(num)
    );
    
    create sequence board_seq start with 1 increment by 1 nomaxvalue nocache nocycle;
    commit;