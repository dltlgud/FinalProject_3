/* =========================================================
   ȸ�� (MEMBER)
   - PK: EMAIL
   - USER_NO: UNIQUE
   - �ּ�: POSTCODE / ADDRESS / DETAILADDRESS / EXTRAADDRESS
   - Ż�����?: STATUS = 0 �� �� ���?
   - SUSPENDED: 1�̸� �����ڿ� ���� �Ͻ������� ����
   ========================================================= */
CREATE TABLE MEMBER (
    EMAIL              VARCHAR2(100) NOT NULL,                -- ȸ���̸���(PK)
    USER_NO            NUMBER        NOT NULL,                -- ȸ����ȣ(UNIQUE)
    PASSWORD           VARCHAR2(255) NOT NULL,                -- ��й��?(�ؽ�)

    USER_NAME          VARCHAR2(50)  NOT NULL,                -- ȸ����
    NICKNAME           VARCHAR2(50)  NOT NULL,                -- �г���(UNIQUE)
    PHONE              VARCHAR2(20),                           -- �޴�����ȣ
    GENDER             VARCHAR2(1),                                -- ����('M','F')
    BIRTH_DATE         VARCHAR2(8),                            -- �������?('YYYYMMDD')

    POSTCODE           VARCHAR2(5)   NOT NULL,                -- ������ȣ(5�ڸ�)
    ADDRESS            VARCHAR2(200) NOT NULL,                -- �ּ�(�⺻�ּ�)
    DETAILADDRESS      VARCHAR2(200) NOT NULL,                -- ���ּ�
    EXTRAADDRESS       VARCHAR2(200),                          -- �����׸�(��/�ǹ��� ��)

    REG_DATE           DATE DEFAULT SYSDATE NOT NULL,         -- ��������
    LAST_PW_DATE       DATE,                                  -- ��������ȣ�����Ͻ�
    LAST_LOGIN_DATE    DATE,                                  -- �������α�������

    STATUS             NUMBER(1) DEFAULT 1 NOT NULL,          -- 1:��밡��? / 0:Ż��
    IDLE               NUMBER(1) DEFAULT 0 NOT NULL,          -- 0:Ȱ���� / 1:�޸���
    SUSPENDED          NUMBER(1) DEFAULT 0 NOT NULL,          -- 0:���� / 1:�Ͻ�����
    WITHDRAW_REASON    VARCHAR2(500),                         -- Ż�����?(STATUS=0�� �� ���?)

    CASH_BALANCE       NUMBER DEFAULT 0 NOT NULL,             -- ����ĳ��
    MANNER_TEMP        NUMBER DEFAULT 50 NOT NULL,            -- �ųʿµ�(�⺻ 50)

    PROFILE_IMG        VARCHAR2(500),                         -- �������̹���
    RECENT_CATEGORY    VARCHAR2(50),                          -- �ֱٰŷ� ī�װ���
    ROOM_ID            VARCHAR2(100),                         -- ä�ù�Ű(NoSQL��)

    TOSS_CUSTOMER_KEY  VARCHAR2(200),                         -- �佺 ���� Ű
    TOSS_BILLING_KEY   VARCHAR2(200),                         -- �佺 ���� Ű

    CONSTRAINT PK_MEMBER PRIMARY KEY (EMAIL),
    CONSTRAINT UQ_MEMBER_USER_NO UNIQUE (USER_NO),
    CONSTRAINT UQ_MEMBER_NICKNAME UNIQUE (NICKNAME),
    CONSTRAINT CK_MEMBER_STATUS CHECK (STATUS IN (0,1)),
    CONSTRAINT CK_MEMBER_IDLE CHECK (IDLE IN (0,1)),
    CONSTRAINT CK_MEMBER_SUSPENDED CHECK (SUSPENDED IN (0,1)),
    CONSTRAINT CK_MEMBER_GENDER CHECK (GENDER IN ('M','F'))
);

CREATE SEQUENCE SEQ_USER_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

/* =========================================================
 ����(����) ���̺� 
   ========================================================= */
CREATE TABLE AUTHORITIES (
    AUTH_NO     NUMBER NOT NULL,               -- PK
    EMAIL       VARCHAR2(100) NOT NULL,         -- MEMBER.EMAIL FK
    AUTHORITY   VARCHAR2(50) NOT NULL,          -- ��: ROLE_USER, ROLE_ADMIN

    CONSTRAINT PK_AUTHORITIES PRIMARY KEY (AUTH_NO),
    CONSTRAINT UQ_AUTHORITIES UNIQUE (EMAIL, AUTHORITY),

    CONSTRAINT FK_AUTHORITIES_MEMBER FOREIGN KEY (EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT CK_AUTHORITIES_ROLE CHECK (SUBSTR(AUTHORITY, 1, 5) = 'ROLE_')
);

CREATE SEQUENCE SEQ_AUTHORITIES_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

/* =========================================================
    ī�װ��� (CATEGORY)
   ========================================================= */
CREATE TABLE CATEGORY (
  CATEGORY_NO   NUMBER         NOT NULL,     -- ī�װ�����ȣ(PK)
  CATEGORY_NAME VARCHAR2(100)  NOT NULL,     -- ī�װ�����

  CONSTRAINT PK_CATEGORY PRIMARY KEY (CATEGORY_NO)
);

CREATE SEQUENCE SEQ_CATEGORY_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

select *
from REGION;

/* =========================================================
   ���� (REGION)
   ========================================================= */
CREATE TABLE REGION (
  REGION_NO          NUMBER         NOT NULL,          -- ������ȣ(PK)
  REGION_NAME        VARCHAR2(100)  NOT NULL,          -- ������
  PARENT_REGION_NO   NUMBER         NULL,              -- ����������ȣ(FK, �ڱ�����)
  LATITUDE           NUMBER(10,7)   NULL,              -- ����
  LONGITUDE          NUMBER(10,7)   NULL,              -- �浵

  CONSTRAINT PK_REGION PRIMARY KEY (REGION_NO),
  CONSTRAINT FK_REGION_PARENT FOREIGN KEY (PARENT_REGION_NO)
    REFERENCES REGION(REGION_NO)
);

CREATE SEQUENCE SEQ_REGION_NO
START WITH 1 
INCREMENT BY 1
NOMAXVALUE 
NOMINVALUE
NOCYCLE 
NOCACHE;


/* =========================================================
   ȸ������ (MEMBER_REGION)
   - ��å: ȸ���� ���� �ּ� 1�� ~ �ִ� 3��
   ========================================================= */

CREATE TABLE MEMBER_REGION (
  MEMBER_REGION_NO   NUMBER          NOT NULL,         -- ȸ��������ȣ(PK)
  MEMBER_EMAIL       VARCHAR2(100)   NOT NULL,         -- ȸ���̸���(FK)
  REGION_NO          NUMBER          NOT NULL,         -- ������ȣ(FK)

  IS_ACTIVE          VARCHAR2(1) DEFAULT 'Y' NOT NULL,     -- ����Ȱ����������(Y/N)
  IS_VERIFIED        VARCHAR2(1) DEFAULT 'N' NOT NULL,     -- ������������(Y/N)

  CONSTRAINT PK_MEMBER_REGION PRIMARY KEY (MEMBER_REGION_NO),

  -- ? ���� ���� �ߺ� ���? ����
  CONSTRAINT UQ_MEMBER_REGION_MEMBER_REGION UNIQUE (MEMBER_EMAIL, REGION_NO),

  CONSTRAINT FK_MEMBER_REGION_MEMBER FOREIGN KEY (MEMBER_EMAIL)
    REFERENCES MEMBER(EMAIL),

  CONSTRAINT FK_MEMBER_REGION_REGION FOREIGN KEY (REGION_NO)
    REFERENCES REGION(REGION_NO),

  CONSTRAINT CK_MEMBER_REGION_ACTIVE CHECK (IS_ACTIVE IN ('Y','N')),
  CONSTRAINT CK_MEMBER_REGION_VERIFIED CHECK (IS_VERIFIED IN ('Y','N'))
);

CREATE SEQUENCE SEQ_MEMBER_REGION_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
   �����? (DELIVERY_ADDRESS)
   - ��å: �⺻(��ǥ) �������? MEMBER �����ּ�
   - DELIVERY_ADDRESS�� �߰��������? ���� (��ǥ�����? �÷� ����)
   ========================================================= */
CREATE TABLE DELIVERY_ADDRESS (
  DELIVERY_NO        NUMBER         NOT NULL,                 -- ��������?(PK)
  MEMBER_EMAIL       VARCHAR2(100)  NOT NULL,                 -- ȸ���̸���(FK)

  LABEL              VARCHAR2(30)   DEFAULT '�߰������?' NOT NULL, -- �������?(��/ȸ�� ��)
  RECEIVER_NAME      VARCHAR2(50)   NOT NULL,                 -- ������
  RECEIVER_PHONE     VARCHAR2(20)   NOT NULL,                 -- ������ ��ȭ��ȣ

  POSTCODE           VARCHAR2(5)    NOT NULL,                 -- ������ȣ(5�ڸ�)
  ADDRESS            VARCHAR2(200)  NOT NULL,                 -- �ּ�(�⺻�ּ�)
  DETAILADDRESS      VARCHAR2(200)  NOT NULL,                 -- ���ּ�
  EXTRAADDRESS       VARCHAR2(200),                            -- �����׸�(��/�ǹ��� ��)

  IS_PRIMARY         VARCHAR2(1) DEFAULT 'N' NOT NULL
                     CHECK (IS_PRIMARY IN ('Y','N')),

  CONSTRAINT PK_DELIVERY_ADDRESS PRIMARY KEY (DELIVERY_NO),

  CONSTRAINT FK_DELIVERY_MEMBER FOREIGN KEY (MEMBER_EMAIL)
    REFERENCES MEMBER(EMAIL) ON DELETE CASCADE
);

-- [기존 DB ?��?�� ?��] ALTER TABLE DELIVERY_ADDRESS ADD IS_PRIMARY VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK (IS_PRIMARY IN ('Y','N'));

CREATE SEQUENCE SEQ_DELIVERY_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
    ��ǰ (PRODUCTS)
   - �̹��� �÷� ����: ��ǥ�̹����� PRODUCT_IMAGE���� ����
   - �Ǹ�/����/���? ��ǰ ���?
   - �����? PRODUCT_PRICE = ���۰�
   - ���ŷ��� �ּ� + ��ǥ(��/�浵) �ʼ�
   ========================================================= */
CREATE TABLE PRODUCTS (
  PRODUCT_NO        NUMBER           NOT NULL,         -- ��ǰ��ȣ(PK)
  SELLER_EMAIL      VARCHAR2(100)    NOT NULL,         -- �Ǹ��� �̸���(FK)
  CATEGORY_NO       NUMBER           NOT NULL,         -- ī�װ�����ȣ(FK)

  SALE_TYPE         VARCHAR2(20)     NOT NULL,         -- �Ǹ�����(�Ǹ�/����/���?)
  PRODUCT_NAME      VARCHAR2(200)    NOT NULL,         -- ��ǰ��
  PRODUCT_PRICE     NUMBER           NULL,             -- ����(�Ǹ�) / 0 or NULL(����) / ���۰�(���?)
  PRODUCT_DESC      CLOB             NULL,             -- ����

  PRODUCT_CONDITION VARCHAR2(10)     NOT NULL,         -- ����(��/��/��)
  TRADE_STATUS      VARCHAR2(20)     NOT NULL,         -- �ŷ�����(�Ǹ���/������/�ǸſϷ�)
  TRADE_METHOD      VARCHAR2(20)     NOT NULL,         -- �ŷ����?(�ù�/���ŷ�)

  PARCEL_TYPE       VARCHAR2(20)     NULL,             -- �ù�����(�ù��� ����)
  SHIPPING_FEE      NUMBER           NULL,             -- ��ۺ�?(�ù��� ����)

  MEET_PLACE_NAME   VARCHAR2(200)    NULL,             -- ���ŷ� ��Ҹ�?(���ŷ��� ����)
  MEET_ADDRESS      VARCHAR2(300)    NULL,             -- ���ŷ� �ּ�(���ŷ��� ����)
  MEET_LATITUDE     NUMBER(10,7)     NULL,             -- ����(���ŷ��� ����)
  MEET_LONGITUDE    NUMBER(10,7)     NULL,             -- �浵(���ŷ��� ����)

  VIEW_COUNT        NUMBER DEFAULT 0 NOT NULL,         -- ��ȸ��
  REG_DATE          DATE DEFAULT SYSDATE NOT NULL,     -- �����?

  CONSTRAINT PK_PRODUCTS PRIMARY KEY (PRODUCT_NO),

  CONSTRAINT FK_PRODUCTS_SELLER FOREIGN KEY (SELLER_EMAIL)
    REFERENCES MEMBER(EMAIL),

  CONSTRAINT FK_PRODUCTS_CATEGORY FOREIGN KEY (CATEGORY_NO)
    REFERENCES CATEGORY(CATEGORY_NO),

  CONSTRAINT CK_PRODUCTS_SALE_TYPE CHECK (SALE_TYPE IN ('�Ǹ�','����','���?')),
  CONSTRAINT CK_PRODUCTS_CONDITION CHECK (PRODUCT_CONDITION IN ('��','��','��')),
  CONSTRAINT CK_PRODUCTS_TRADE_STATUS CHECK (TRADE_STATUS IN ('�Ǹ���','������','�ǸſϷ�')),
  CONSTRAINT CK_PRODUCTS_TRADE_METHOD CHECK (TRADE_METHOD IN ('�ù�','���ŷ�')),

  -- SALE_TYPE�� ���� ��Ģ: �Ǹ�(>0), ����(0 �Ǵ� NULL), ���?(���۰� >0)
  CONSTRAINT CK_PRODUCTS_PRICE_BY_SALETYPE CHECK (
    (SALE_TYPE = '�Ǹ�' AND PRODUCT_PRICE IS NOT NULL AND PRODUCT_PRICE > 0)
    OR
    (SALE_TYPE = '����' AND (PRODUCT_PRICE IS NULL OR PRODUCT_PRICE = 0))
    OR
    (SALE_TYPE = '���?' AND PRODUCT_PRICE IS NOT NULL AND PRODUCT_PRICE > 0)
  ),

  CONSTRAINT CK_PRODUCTS_SHIPPING_FEE CHECK (SHIPPING_FEE IS NULL OR SHIPPING_FEE >= 0),
  CONSTRAINT CK_PRODUCTS_VIEW_COUNT CHECK (VIEW_COUNT >= 0),

  -- �ù��? �ù�����/��ۺ�? �ʼ�, ���ŷ��� �ù����? NULL
  CONSTRAINT CK_PRODUCTS_PARCEL_BY_METHOD CHECK (
    (TRADE_METHOD = '�ù�' AND PARCEL_TYPE IN ('�Ϲ��ù�','CU�ݰ�','GS�ݰ�') AND SHIPPING_FEE IS NOT NULL)
    OR
    (TRADE_METHOD = '���ŷ�' AND PARCEL_TYPE IS NULL AND SHIPPING_FEE IS NULL)
  ),

  -- ���ŷ��� �ּ�+��ǥ �ʼ�, �ù��? ���ŷ� ���� ���� NULL
  CONSTRAINT CK_PRODUCTS_MEET_BY_METHOD CHECK (
    (TRADE_METHOD = '���ŷ�'
      AND MEET_ADDRESS IS NOT NULL
      AND MEET_LATITUDE IS NOT NULL
      AND MEET_LONGITUDE IS NOT NULL)
    OR
    (TRADE_METHOD = '�ù�'
      AND MEET_PLACE_NAME IS NULL
      AND MEET_ADDRESS IS NULL
      AND MEET_LATITUDE IS NULL
      AND MEET_LONGITUDE IS NULL)
  )
);

CREATE SEQUENCE SEQ_PRODUCT_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;




/* =========================================================
    ä�ù� (CHAT_ROOM)
   ========================================================= */
CREATE TABLE CHAT_ROOM (
    ROOM_ID             VARCHAR2(100) PRIMARY KEY,    -- ä�ù� Ű
    PRODUCT_NO          NUMBER NOT NULL,              -- ��ǰ��ȣ(FK)

    SELLER_EMAIL        VARCHAR2(100) NOT NULL,       -- �Ǹ���
    BUYER_EMAIL         VARCHAR2(100) NOT NULL,       -- ������

    RESERVE_TIME        DATE,                         -- ����ð�?
    RESERVE_PLACE       VARCHAR2(300),                -- �������?

    LAST_MESSAGE        VARCHAR2(1000),               -- �ֱٴ�ȭ����(�̸�����)
    LAST_MESSAGE_AT     DATE,                         -- �ֱٴ�ȭ�ð�(���? ���Ŀ� ĳ��)

    MUTE_YN             VARCHAR2(1) DEFAULT 'N' NOT NULL, -- �˸�����(Y/N)

    CONSTRAINT FK_CHAT_PRODUCT FOREIGN KEY (PRODUCT_NO)
      REFERENCES PRODUCTS(PRODUCT_NO) ON DELETE CASCADE,

    CONSTRAINT FK_CHAT_SELLER FOREIGN KEY (SELLER_EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT FK_CHAT_BUYER FOREIGN KEY (BUYER_EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT UQ_CHAT_ROOM_PAIR UNIQUE (PRODUCT_NO, SELLER_EMAIL, BUYER_EMAIL),
    CONSTRAINT CK_CHAT_ROOM_SELF CHECK (SELLER_EMAIL <> BUYER_EMAIL),
    CONSTRAINT CK_CHAT_ROOM_MUTE CHECK (MUTE_YN IN ('Y','N'))
);


/* =========================================================
    �޸հ��� (USER_DORMANT)
   ========================================================= */
CREATE TABLE USER_DORMANT (
    EMAIL              VARCHAR2(100) PRIMARY KEY,     -- �̸���(PK �� FK)
    DORMANT_DATE       DATE DEFAULT SYSDATE,          -- �޸���ȯ�Ͻ�
    PHONE              VARCHAR2(20),                  -- �޴�����ȣ
    BIRTH_DATE         VARCHAR2(8),                   -- �������?
    GENDER             VARCHAR2(1),                       -- ����
    USER_NAME          VARCHAR2(50) NOT NULL,         -- �̸�
    ORIGINAL_REG_DATE  DATE,                          -- ���������Ͻ�
    CASH_BALANCE       NUMBER DEFAULT 0,              -- ����ĳ��

    CONSTRAINT FK_DORMANT_MEMBER FOREIGN KEY (EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE
);


/* =========================================================
   �α��� ���? (LOGIN_HISTORY)
   ========================================================= */
CREATE TABLE LOGIN_HISTORY (
    HISTORY_NO     NUMBER NOT NULL,                       -- ��Ϲ��?(PK)
    EMAIL          VARCHAR2(100) NOT NULL,                 -- ȸ���̸���(FK)
    LOGIN_DATE     DATE DEFAULT SYSDATE NOT NULL,          -- �α����Ͻ�
    LOGIN_IP       VARCHAR2(45) NOT NULL,                  -- ����IP

    CONSTRAINT PK_LOGIN_HISTORY PRIMARY KEY (HISTORY_NO),

    CONSTRAINT FK_LOGIN_MEMBER FOREIGN KEY (EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE
);

CREATE SEQUENCE SEQ_HISTORYNO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

/* =========================================================
    ���� (USER_BLOCK)
   - ���� ���� �����? ȸ���̾��? �Ѵٸ� BLOCKED_EMAIL FK �߰�
   - �ڱ� �ڽ� ���� ���� üũ �߰�
   ========================================================= */
CREATE TABLE USER_BLOCK (
    BLOCK_NO       NUMBER PRIMARY KEY,               -- ���ܽĺ��ڵ�(PK)
    EMAIL          VARCHAR2(100) NOT NULL,            -- ���� ������(FK)
    BLOCKED_EMAIL  VARCHAR2(100) NOT NULL,            -- ������ �̸���(FK)
    BLOCK_DATE     DATE DEFAULT SYSDATE,             -- �����Ͻ�

    CONSTRAINT FK_BLOCK_MEMBER FOREIGN KEY (EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT FK_BLOCK_BLOCKED_MEMBER FOREIGN KEY (BLOCKED_EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT CK_BLOCK_NOT_SELF CHECK (EMAIL <> BLOCKED_EMAIL)
);



/* =========================================================
    ��ǰ�̹��� (PRODUCT_IMAGE)
   - ��ǥ�̹����� IS_MAIN='Y' �θ� ����
   - ����/URL �� �ϳ��� �ݵ��? ����
   ========================================================= */
CREATE TABLE PRODUCT_IMAGE (
  PRD_IMG_NO       NUMBER           NOT NULL,        -- ��ǰ�̹�����ȣ(PK)
  PRODUCT_NO       NUMBER           NOT NULL,        -- ��ǰ��ȣ(FK)

  IMG_URL          VARCHAR2(500)    NULL,            -- �̹��� URL/���?(���� ���� ���? ��)
  ORGFILENAME      VARCHAR2(255)    NULL,            -- ���ε� �������ϸ�
  FILENAME         VARCHAR2(255)    NULL,            -- ���� �������ϸ�

  SORT_NO          NUMBER DEFAULT 1 NOT NULL,        -- ���ļ���(1����)
  IS_MAIN          VARCHAR2(1) DEFAULT 'N' NOT NULL,     -- ��ǥ����(Y/N)

  CONSTRAINT PK_PRODUCT_IMAGE PRIMARY KEY (PRD_IMG_NO),

  CONSTRAINT FK_PRODUCT_IMAGE_PRODUCT FOREIGN KEY (PRODUCT_NO)
    REFERENCES PRODUCTS(PRODUCT_NO) ON DELETE CASCADE,

  CONSTRAINT CK_PRODUCT_IMAGE_SORT CHECK (SORT_NO >= 1),
  CONSTRAINT CK_PRODUCT_IMAGE_IS_MAIN CHECK (IS_MAIN IN ('Y','N')),
  CONSTRAINT CK_PRODUCT_IMAGE_FILE CHECK (IMG_URL IS NOT NULL OR FILENAME IS NOT NULL)
);

CREATE SEQUENCE SEQ_PRODUCT_IMAGE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- (����) ��ǥ�̹���(Y)�� ��ǰ�� 1���� ���? (Oracle: �Լ� ���? ����ũ �ε���)
CREATE UNIQUE INDEX UQ_PRODUCT_MAIN_IMAGE
ON PRODUCT_IMAGE (
  CASE WHEN IS_MAIN = 'Y' THEN PRODUCT_NO END
);

-- (����) ���? ��ȸ/���� ���ɿ�
CREATE INDEX IDX_PRODUCT_IMAGE_PRODUCT ON PRODUCT_IMAGE(PRODUCT_NO);
CREATE INDEX IDX_PRODUCT_IMAGE_MAIN   ON PRODUCT_IMAGE(PRODUCT_NO, IS_MAIN);


/* =========================================================
    ���? (AUCTION)
   ========================================================= */
CREATE TABLE AUCTION (
  AUCTION_NO       NUMBER          NOT NULL,         -- ��Ź��?(PK)
  PRODUCT_NO       NUMBER          NOT NULL,         -- ��ǰ��ȣ(FK)

  TOP_BIDDER_EMAIL VARCHAR2(100)   NULL,             -- �����ְ������� �̸���(FK)
  START_AT         TIMESTAMP       NOT NULL,         -- �����Ͻ�
  END_AT           TIMESTAMP       NOT NULL,         -- �����Ͻ�
  BID_UNIT         NUMBER DEFAULT 5000 NOT NULL,     -- ��������(����)
  BUY_NOW_PRICE    NUMBER          NULL,             -- ��ñ��Ű�?

  CONSTRAINT PK_AUCTION PRIMARY KEY (AUCTION_NO),

  CONSTRAINT FK_AUCTION_PRODUCT FOREIGN KEY (PRODUCT_NO)
    REFERENCES PRODUCTS(PRODUCT_NO) ON DELETE CASCADE,

  CONSTRAINT FK_AUCTION_TOP_BIDDER FOREIGN KEY (TOP_BIDDER_EMAIL)
    REFERENCES MEMBER(EMAIL),

  CONSTRAINT CK_AUCTION_BID_UNIT CHECK (BID_UNIT = 5000),
  CONSTRAINT CK_AUCTION_TIME CHECK (END_AT > START_AT),
  CONSTRAINT CK_AUCTION_BUY_NOW CHECK (BUY_NOW_PRICE IS NULL OR BUY_NOW_PRICE > 0)
);

CREATE SEQUENCE SEQ_AUCTION_NO
START WITH 1 INCREMENT BY 1
NOMAXVALUE NOMINVALUE
NOCYCLE NOCACHE;


/* =========================================================
    �������? (AUCTION_BID)
   ========================================================= */
CREATE TABLE AUCTION_BID (
  AUCTION_BID_NO   NUMBER          NOT NULL,         -- ������ȣ(PK)
  AUCTION_NO       NUMBER          NOT NULL,         -- ��Ź��?(FK)
  BIDDER_EMAIL     VARCHAR2(100)   NOT NULL,         -- ������ �̸���(FK)
  BID_AMOUNT       NUMBER          NOT NULL,         -- �����ݾ�
  BID_AT           TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL, -- �����Ͻ�

  CONSTRAINT PK_AUCTION_BID PRIMARY KEY (AUCTION_BID_NO),

  CONSTRAINT FK_AUCTION_BID_AUCTION FOREIGN KEY (AUCTION_NO)
    REFERENCES AUCTION(AUCTION_NO) ON DELETE CASCADE,

  CONSTRAINT FK_AUCTION_BID_BIDDER FOREIGN KEY (BIDDER_EMAIL)
    REFERENCES MEMBER(EMAIL),

  CONSTRAINT CK_AUCTION_BID_AMOUNT CHECK (BID_AMOUNT > 0)
);

CREATE SEQUENCE SEQ_AUCTION_BID_NO
START WITH 1 INCREMENT BY 1
NOMAXVALUE NOMINVALUE
NOCYCLE NOCACHE;


/* =========================================================
    ��ȸ�� ��ġ (GUEST_REGION)
   ========================================================= */
CREATE TABLE GUEST_REGION (
  GUEST_REGION_NO   NUMBER          NOT NULL,        -- PK
  GUEST_KEY         VARCHAR2(100)   NOT NULL,        -- ����/����̽�?/��ŰŰ
  REGION_NO         NUMBER          NOT NULL,        -- ������ȣ(FK)

  LATITUDE          NUMBER(10,7)    NULL,            -- ����
  LONGITUDE         NUMBER(10,7)    NULL,            -- �浵
  UPDATED_AT        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL, -- ���Žð�

  CONSTRAINT PK_GUEST_REGION PRIMARY KEY (GUEST_REGION_NO),
  CONSTRAINT UQ_GUEST_REGION_KEY UNIQUE (GUEST_KEY),
  CONSTRAINT FK_GUEST_REGION_REGION FOREIGN KEY (REGION_NO)
    REFERENCES REGION(REGION_NO)
);

CREATE SEQUENCE SEQ_GUEST_REGION_NO
START WITH 1 INCREMENT BY 1
NOMAXVALUE NOMINVALUE
NOCYCLE NOCACHE;


/* =========================================================
    �α�˻���? (POPULAR_KEYWORD)
   ========================================================= */
CREATE TABLE POPULAR_KEYWORD (
  KEYWORD_NO      NUMBER          NOT NULL,          -- �˻�����?(PK)
  KEYWORD_TEXT    VARCHAR2(200)   NOT NULL,          -- �˻���
  SEARCHED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL, -- �˻��Ͻ�
  SEARCH_COUNT    NUMBER DEFAULT 1 NOT NULL,         -- �˻�Ƚ��

  CONSTRAINT PK_POPULAR_KEYWORD PRIMARY KEY (KEYWORD_NO),
  CONSTRAINT CK_POPULAR_KEYWORD_COUNT CHECK (SEARCH_COUNT >= 1)
);

CREATE SEQUENCE SEQ_POPULAR_KEYWORD_NO
START WITH 1 INCREMENT BY 1
NOMAXVALUE NOMINVALUE
NOCYCLE NOCACHE;


/* =========================================================
    �� (WISHLIST)
   ========================================================= */
CREATE TABLE WISHLIST (
  MEMBER_EMAIL   VARCHAR2(100)  NOT NULL,            -- ȸ���̸���(FK)
  PRODUCT_NO     NUMBER         NOT NULL,            -- ��ǰ��ȣ(FK)

  CONSTRAINT PK_WISHLIST PRIMARY KEY (MEMBER_EMAIL, PRODUCT_NO),

  CONSTRAINT FK_WISHLIST_MEMBER FOREIGN KEY (MEMBER_EMAIL)
    REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

  CONSTRAINT FK_WISHLIST_PRODUCT FOREIGN KEY (PRODUCT_NO)
    REFERENCES PRODUCTS(PRODUCT_NO) ON DELETE CASCADE
);

CREATE INDEX IDX_WISHLIST_MEMBER  ON WISHLIST(MEMBER_EMAIL);
CREATE INDEX IDX_WISHLIST_PRODUCT ON WISHLIST(PRODUCT_NO);


/* =========================================================
    �Ű����� (REPORT_TYPES)
   ========================================================= */
CREATE TABLE REPORT_TYPES (
    TYPE_ID    NUMBER PRIMARY KEY,                   -- �Ű�������ȣ(PK)
    TYPE_NAME  VARCHAR2(100) NOT NULL                -- �Ű������� (��: �弳, ����, ���?)

);





/* =========================================================
    �������� (NOTICES)  �� 1���� ����
   ========================================================= */
CREATE TABLE NOTICES (
    NOTICE_ID     NUMBER PRIMARY KEY,                 -- �������׹�ȣ(PK)
    ADMIN_EMAIL   VARCHAR2(100) NOT NULL,             -- �ۼ� ������ �̸���(FK: MEMBER.EMAIL)
    TITLE         VARCHAR2(400) NOT NULL,             -- ����
    CONTENT       CLOB NOT NULL,                      -- ����
    VIEW_COUNT    NUMBER DEFAULT 0,                   -- ��ȸ��
    IMAGE_PATH    VARCHAR2(500),                      -- �̹��� ���?
    IMPORTANCE    NUMBER(1) DEFAULT 0,                -- �߿䵵(0/1)
    STATUS        VARCHAR2(20) DEFAULT 'PUBLISHED',   -- �Խû���
    IS_DELETED    VARCHAR2(1) DEFAULT 'N',                -- ��������(Y/N)
    CREATED_AT    DATE DEFAULT SYSDATE,               -- �����?

    CONSTRAINT FK_NOTICE_ADMIN_EMAIL FOREIGN KEY (ADMIN_EMAIL)
      REFERENCES MEMBER(EMAIL),

    CONSTRAINT CK_NOTICE_IMPORTANCE CHECK (IMPORTANCE IN (0,1)),
    CONSTRAINT CK_NOTICE_DELETED CHECK (IS_DELETED IN ('Y','N'))
);

CREATE SEQUENCE SEQ_NOTICE_ID
START WITH 1 INCREMENT BY 1
NOMAXVALUE NOMINVALUE
NOCYCLE NOCACHE;



/* =========================================================
    �̺�Ʈ (EVENTS)
   - BANNER_IMAGE_URL : ����/���? ��ʿ�?
   - IMAGE_URL        : �� ������ ��ǥ �̹���(�Ǵ� �� �����?)
   ========================================================= */
CREATE TABLE EVENTS (
    EVENT_ID          NUMBER PRIMARY KEY,               -- �̺�Ʈ��ȣ(PK)
    ADMIN_EMAIL       VARCHAR2(100) NOT NULL,           -- ���? ������ �̸���(FK: MEMBER.EMAIL)

    TITLE             VARCHAR2(200) NOT NULL,           -- ����
    CONTENT           CLOB NOT NULL,                    -- ����

    BANNER_IMAGE_URL  VARCHAR2(512),                    -- ���? �̹��� (���?/�����̵��?)
    IMAGE_URL         VARCHAR2(512),                    -- �� �̹��� (����������)

    START_DATE        DATE NOT NULL,                    -- ������
    END_DATE          DATE NOT NULL,                    -- ������
    CREATED_AT        DATE DEFAULT SYSDATE,             -- �����?

    REWARD_CASH       NUMBER DEFAULT 0,                 -- ����ĳ��
    STATUS            VARCHAR2(20) DEFAULT 'READY',     -- ����
    VIEW_COUNT        NUMBER DEFAULT 0,                 -- ��ȸ��

    CONSTRAINT FK_EVENT_ADMIN_EMAIL FOREIGN KEY (ADMIN_EMAIL)
      REFERENCES MEMBER(EMAIL),

    CONSTRAINT CHK_EVENT_DATE CHECK (END_DATE > START_DATE)
);

CREATE SEQUENCE SEQ_EVENT_ID
START WITH 1 
INCREMENT BY 1
NOMAXVALUE 
NOMINVALUE
NOCYCLE 
NOCACHE;


/* =========================================================
    �̺�Ʈ ���? (EVENT_COMMENTS)
   ========================================================= */
CREATE TABLE EVENT_COMMENTS (
    COMMENT_ID   NUMBER PRIMARY KEY,                -- ��۹��?(PK)
    EVENT_ID     NUMBER NOT NULL,                   -- �̺�Ʈ��ȣ(FK)
    MEMBER_EMAIL VARCHAR2(100) NOT NULL,            -- ȸ���̸���(FK)
    CONTENT      VARCHAR2(600) NOT NULL,            -- ��۳���?
    CREATED_AT   DATE DEFAULT SYSDATE,              -- �ۼ���

    CONSTRAINT UK_EVENT_MEMBER UNIQUE (EVENT_ID, MEMBER_EMAIL),

    CONSTRAINT FK_COMM_EVENT FOREIGN KEY (EVENT_ID)
      REFERENCES EVENTS(EVENT_ID),

    CONSTRAINT FK_COMM_MEMBER FOREIGN KEY (MEMBER_EMAIL)
      REFERENCES MEMBER(EMAIL)
);

CREATE SEQUENCE SEQ_COMMENT_ID
START WITH 1 
INCREMENT BY 1
NOMAXVALUE 
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
   ���� (INQUIRIES)
   ========================================================= */
CREATE TABLE INQUIRIES (
    INQUIRY_ID       NUMBER NOT NULL,                     -- ���ǹ�ȣ(PK)
    MEMBER_EMAIL     VARCHAR2(100) NOT NULL,               -- ȸ���̸���(FK)
    TITLE            VARCHAR2(200) NOT NULL,               -- ����
    CONTENT          CLOB NOT NULL,                        -- ����
    CREATED_AT       DATE DEFAULT SYSDATE NOT NULL,        -- �ۼ���

    INQUIRY_STATUS   VARCHAR2(20) DEFAULT '���?' NOT NULL, -- �亯����(���?, �亯�Ϸ�)
    ADMIN_ANSWER     CLOB,                                 -- ������ �亯
    ANSWERED_AT      DATE,                                 -- �亯 �ۼ� �ð�

    CONSTRAINT PK_INQUIRIES PRIMARY KEY (INQUIRY_ID),

    CONSTRAINT FK_INQ_MEMBER FOREIGN KEY (MEMBER_EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT CK_INQUIRY_STATUS CHECK (INQUIRY_STATUS IN ('���?','�亯�Ϸ�')),

    -- ���º� ���ռ�(�ٽ�)
    CONSTRAINT CK_INQUIRY_STATUS_DETAIL CHECK (
        (INQUIRY_STATUS = '���?'     AND ADMIN_ANSWER IS NULL AND ANSWERED_AT IS NULL)
     OR (INQUIRY_STATUS = '�亯�Ϸ�' AND ADMIN_ANSWER IS NOT NULL AND ANSWERED_AT IS NOT NULL)
    )
);

CREATE SEQUENCE SEQ_INQUIRY_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
   ���� ���� (ACCOUNTS)
   ========================================================= */
CREATE TABLE ACCOUNTS (
    ACCOUNT_ID      NUMBER          PRIMARY KEY,     -- ���¹�ȣ(PK)
    EMAIL           VARCHAR2(100)   NOT NULL,        -- ������ �̸���(FK)
    BANK_NAME       VARCHAR2(50)    NOT NULL,        -- �����?
    ACCOUNT_NUM     VARCHAR2(50)    NOT NULL,        -- ���¹�ȣ
    ACCOUNT_HOLDER  VARCHAR2(50)    NOT NULL,        -- ������
    IS_PRIMARY      VARCHAR2(1) DEFAULT 'N'
                    CHECK (IS_PRIMARY IN ('Y','N')), -- ��ǥ����(Y/N)

    CONSTRAINT FK_ACCT_MEMBER FOREIGN KEY (EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE
);

CREATE SEQUENCE SEQ_ACCOUNT_ID
START WITH 1 
INCREMENT BY 1
NOMAXVALUE 
NOMINVALUE
NOCYCLE
NOCACHE;

/* =========================================================
    �ŷ�/���� (TRANSACTIONS)
   - �佺 ���� �ĺ�/���¸� �ּ� ����
   - ��(ī��/�������?/��������/�α�)�� ���� ���̺����� ����
   - ä��(������ü) / ĳ�ð��� / �佺����(ī��/����/����) ���? ����
   ========================================================= */
CREATE TABLE TRANSACTIONS (
    TRANSACTION_ID   NUMBER          NOT NULL,                 -- �ŷ�/������ȣ(PK)
    PRODUCT_NO       NUMBER          NOT NULL,                 -- ��ǰ��ȣ(FK)
    SELLER_EMAIL     VARCHAR2(100)   NOT NULL,                 -- �Ǹ��� �̸���(FK)
    BUYER_EMAIL      VARCHAR2(100),                            -- ������ �̸���(FK, ������ NULL ����)
    ACCOUNT_ID       NUMBER,                                   -- ���� ����(FK, ���� �����? ����)

    PAYMENT_TYPE     VARCHAR2(30)    NOT NULL,                 -- ��������
    AMOUNT           NUMBER(12,0)    NOT NULL,                 -- �����ݾ�(0 �̻�)
    TRADE_STATUS     VARCHAR2(20)    DEFAULT '�ŷ���' NOT NULL,-- �ŷ�����
    TRADE_DATE       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    COMPLETE_DATE    TIMESTAMP,

    /* ===== �佺 �ּ� �÷�(���� �ĺ�/���� ĳ��) ===== */
    TOSS_PAY_KEY     VARCHAR2(200),                            -- (�佺) ����Ű
    TOSS_ORDER_ID    VARCHAR2(200),                            -- (�佺) �ֹ�ID(�佺 ��û/������)
    PAY_STATUS       VARCHAR2(20)    DEFAULT 'READY' NOT NULL, -- (�佺) �������� ĳ��
    APPROVED_AT      TIMESTAMP,                                -- (�佺) ���νð�(ĳ��)

    USE_ESCROW       VARCHAR2(1) DEFAULT 'N' NOT NULL,             -- ��������(����ũ��) ����(Y/N)

    CONSTRAINT PK_TRANSACTIONS PRIMARY KEY (TRANSACTION_ID),

    CONSTRAINT FK_TXN_PRODUCT  FOREIGN KEY (PRODUCT_NO)
      REFERENCES PRODUCTS(PRODUCT_NO),

    CONSTRAINT FK_TXN_SELLER   FOREIGN KEY (SELLER_EMAIL)
      REFERENCES MEMBER(EMAIL),

    CONSTRAINT FK_TXN_BUYER    FOREIGN KEY (BUYER_EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE SET NULL,

    CONSTRAINT FK_TXN_ACCOUNT  FOREIGN KEY (ACCOUNT_ID)
      REFERENCES ACCOUNTS(ACCOUNT_ID) ON DELETE SET NULL,

    /* ===== �� ���� ===== */
    CONSTRAINT CK_TXN_AMOUNT CHECK (AMOUNT >= 0),

    CONSTRAINT CK_TXN_PAYMENT_TYPE CHECK (
      PAYMENT_TYPE IN ('������ü','ĳ�ð���','ī�����?','�������?','��������')
    ),

    CONSTRAINT CK_TXN_TRADE_STATUS CHECK (
      TRADE_STATUS IN ('�ŷ���','�ŷ��Ϸ�','���?','ȯ����','ȯ�ҿϷ�')
    ),

    CONSTRAINT CK_TXN_PAY_STATUS CHECK (
      PAY_STATUS IN ('READY','IN_PROGRESS','WAITING_FOR_DEPOSIT',
                     'DONE','CANCELED','PARTIAL_CANCELED','ABORTED','EXPIRED')
    ),

    CONSTRAINT CK_TXN_USE_ESCROW CHECK (USE_ESCROW IN ('Y','N')),

    /* ===== �佺 �ּ� ���ռ�(�佺 ���������� ���� �佺 �ֹ�ID/����Ű ���?) ===== */
    CONSTRAINT CK_TXN_TOSS_MINIMAL CHECK (
      (PAYMENT_TYPE IN ('ī�����?','�������?','��������')
        AND TOSS_ORDER_ID IS NOT NULL
        AND TOSS_PAY_KEY  IS NOT NULL)
      OR
      (PAYMENT_TYPE IN ('������ü','ĳ�ð���')
        AND TOSS_ORDER_ID IS NULL
        AND TOSS_PAY_KEY  IS NULL)
    )
);

CREATE SEQUENCE SEQ_TRANSACTION_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

/* =========================================================
    �佺 ī�����? �� (TOSS_CARD_PAYMENTS)
   ========================================================= */
CREATE TABLE TOSS_CARD_PAYMENTS (
    CARD_PAY_ID     NUMBER          NOT NULL, -- ī������󼼹��?(PK)
    TRANSACTION_ID  NUMBER          NOT NULL, -- �ŷ�/������ȣ(FK �� TRANSACTIONS.TRANSACTION_ID)

    CARD_COMPANY_CD VARCHAR2(20),             -- ī���? �ڵ�
    CARD_COMPANY    VARCHAR2(50),             -- ī����
    CARD_NUM        VARCHAR2(25),             -- ī����?(����ŷ�� ��)
    CARD_TYPE       VARCHAR2(20),             -- ī�� ����(�ſ�/üũ ��)
    INSTALLMENT     NUMBER(2,0) DEFAULT 0,    -- �Һ� ������(�Ͻú�=0)
    IS_NO_INTEREST  VARCHAR2(1) DEFAULT 'N',      -- ������ ����(Y/N)
    POINT_USED      NUMBER(10,0) DEFAULT 0,   -- ī�� ����Ʈ ���ݾ�
    OWNER_TYPE      VARCHAR2(20),             -- ī�� ������ ����(����/����)
    ACQUIRE_STATUS  VARCHAR2(20),             -- ���� ����
    RECEIPT_URL     VARCHAR2(1000),           -- ī�� ������ URL

    CONSTRAINT PK_TOSS_CARD_PAYMENTS PRIMARY KEY (CARD_PAY_ID), -- PK
    CONSTRAINT FK_CARD_TXN FOREIGN KEY (TRANSACTION_ID)         -- FK
      REFERENCES TRANSACTIONS(TRANSACTION_ID) ON DELETE CASCADE,

    CONSTRAINT CK_CARD_NO_INTEREST CHECK (IS_NO_INTEREST IN ('Y','N'))
);

CREATE SEQUENCE SEQ_CARD_PAY_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
    �佺 �������? �� (TOSS_VIRTUAL_ACCOUNTS)
   ========================================================= */
CREATE TABLE TOSS_VIRTUAL_ACCOUNTS (
    VACCOUNT_ID       NUMBER NOT NULL, -- ������»󼼹��?(PK)
    TRANSACTION_ID    NUMBER NOT NULL, -- �ŷ�/������ȣ(FK �� TRANSACTIONS.TRANSACTION_ID)

    BANK_CODE         VARCHAR2(20),    -- ���� �ڵ�
    BANK_NAME         VARCHAR2(50),    -- �����?
    VACCOUNT_NUM      VARCHAR2(50),    -- �߱޵� ������¹��?
    CUSTOMER_NAME     VARCHAR2(50),    -- �Ա��ڸ�
    DEPOSIT_DEADLINE  TIMESTAMP,       -- �Ա� ��������
    DEPOSIT_STATUS    VARCHAR2(20),    -- �Ա� ����(���?/�Ϸ� ��)
    DEPOSITED_AT      TIMESTAMP,       -- ���� �Ա� �ð�
    REFUND_BANK       VARCHAR2(50),    -- ȯ�� �����?
    REFUND_ACCT_NUM   VARCHAR2(50),    -- ȯ�� ���¹�ȣ
    REFUND_HOLDER     VARCHAR2(50),    -- ȯ�� ���� ������
    CASH_RECEIPT_TYPE VARCHAR2(20),    -- ���ݿ����� ����(�ҵ����?/�������� ��)
    CASH_RECEIPT_NUM  VARCHAR2(50),    -- ���ݿ����� ��ȣ

    CONSTRAINT PK_TOSS_VIRTUAL_ACCOUNTS PRIMARY KEY (VACCOUNT_ID), -- PK
    CONSTRAINT FK_VACCT_TXN FOREIGN KEY (TRANSACTION_ID)           -- FK
      REFERENCES TRANSACTIONS(TRANSACTION_ID) ON DELETE CASCADE
);

CREATE SEQUENCE SEQ_VACCOUNT_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
   �佺 �������� �� (TOSS_EASY_PAYMENTS)
   ========================================================= */
CREATE TABLE TOSS_EASY_PAYMENTS (
    EASY_PAY_ID     NUMBER NOT NULL, -- ���������󼼹�ȣ(PK)
    TRANSACTION_ID  NUMBER NOT NULL, -- �ŷ�/������ȣ(FK �� TRANSACTIONS.TRANSACTION_ID)

    PROVIDER        VARCHAR2(50),    -- �������� ������(īī������/���̹����� ��)
    APPROVAL_NUM    VARCHAR2(50),    -- ���ι�ȣ
    DISCOUNT_AMT    NUMBER(10,0) DEFAULT 0, -- �������� ���αݾ�

    CONSTRAINT PK_TOSS_EASY_PAYMENTS PRIMARY KEY (EASY_PAY_ID), -- PK
    CONSTRAINT FK_EASY_PAY_TXN FOREIGN KEY (TRANSACTION_ID)     -- FK
      REFERENCES TRANSACTIONS(TRANSACTION_ID) ON DELETE CASCADE,

    CONSTRAINT CK_EASY_DISCOUNT CHECK (DISCOUNT_AMT >= 0)
);

CREATE SEQUENCE SEQ_EASY_PAY_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


/* =========================================================
    �佺 ���� �α� (TOSS_PAYMENT_LOGS)
   ========================================================= */
CREATE TABLE TOSS_PAYMENT_LOGS (
    LOG_ID          NUMBER NOT NULL, -- �����α׹�ȣ(PK)
    TRANSACTION_ID  NUMBER,          -- �ŷ�/������ȣ(FK �� TRANSACTIONS.TRANSACTION_ID, ����)

    LOG_TYPE        VARCHAR2(20),    -- �α� ����(��û/����/���� ��)
    API_ENDPOINT    VARCHAR2(200),   -- ȣ�� API ��������Ʈ
    HTTP_METHOD     VARCHAR2(10),    -- HTTP �޼ҵ�(GET/POST ��)
    REQUEST_DATA    CLOB,            -- ��û ������(JSON ����)
    RESPONSE_DATA   CLOB,            -- ���� ������(JSON ����)
    HTTP_STATUS     NUMBER(3,0),     -- HTTP �����ڵ�
    ERROR_CODE      VARCHAR2(50),    -- ���� �ڵ�
    ERROR_MSG       VARCHAR2(500),   -- ���� �޽���
    REQUESTED_AT    TIMESTAMP DEFAULT SYSTIMESTAMP, -- ��û �ð�
    RESPONDED_AT    TIMESTAMP,       -- ���� �ð�
    REQUEST_IP      VARCHAR2(50),    -- ��û IP �ּ�

    CONSTRAINT PK_TOSS_PAYMENT_LOGS PRIMARY KEY (LOG_ID), -- PK
    CONSTRAINT FK_PAYLOG_TXN FOREIGN KEY (TRANSACTION_ID) -- FK
      REFERENCES TRANSACTIONS(TRANSACTION_ID) ON DELETE SET NULL
);

CREATE SEQUENCE SEQ_PAYLOG_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

/* =========================================================
   ȯ�� (REFUNDS)
   ========================================================= */
CREATE TABLE REFUNDS (
    REFUND_ID           NUMBER          NOT NULL, -- ȯ�ҹ�ȣ(PK)
    TRANSACTION_ID      NUMBER          NOT NULL, -- �ŷ�/������ȣ(FK �� TRANSACTIONS.TRANSACTION_ID)

    TOSS_CANCEL_ID      VARCHAR2(200),            -- �佺 ���? ID
    TOSS_CANCEL_KEY     VARCHAR2(200),            -- �佺 ���? Ű

    REFUND_REASON       VARCHAR2(500),            -- ȯ�� ����
    REFUND_AMT          NUMBER(12,0)  NOT NULL,   -- ȯ�� �ݾ�

    REQUESTED_AT        TIMESTAMP DEFAULT SYSTIMESTAMP, -- ȯ�� ��û�Ͻ�
    COMPLETED_AT        TIMESTAMP,                -- ȯ�� �Ϸ��Ͻ�

    REFUND_STATUS       VARCHAR2(20) DEFAULT '��û' NOT NULL, -- ȯ�� ����(��û/ó����/�Ϸ�/����)
    IS_PARTIAL          VARCHAR2(1) DEFAULT 'N',      -- �κ�ȯ�� ����(Y/N)
    CANCEL_AVAIL_BAL    NUMBER(12,0),             -- ���? ���� �ܾ�
    RETURN_STATUS       VARCHAR2(50),             -- ��ǰ ����(�ù�ȸ����/�Ϸ� ��)

    HANDLER_EMAIL       VARCHAR2(100),            -- ó�� ������ �̸���(FK �� MEMBER.EMAIL)
    BANK_NAME           VARCHAR2(50),             -- ȯ�� �����?
    REFUND_ACCT_NUM     VARCHAR2(50),             -- ȯ�� ���¹�ȣ
    ACCOUNT_HOLDER      VARCHAR2(50),             -- �����ָ�

    REFUND_SUPPLY_PRICE NUMBER(12,0),             -- ���ް��� ���� ȯ�ұ�
    REFUND_VAT          NUMBER(12,0),             -- �ΰ��� ȯ�ұ�

    CONSTRAINT PK_REFUNDS PRIMARY KEY (REFUND_ID), -- PK

    CONSTRAINT FK_REFUND_TXN FOREIGN KEY (TRANSACTION_ID) -- FK
      REFERENCES TRANSACTIONS(TRANSACTION_ID) ON DELETE CASCADE,

    CONSTRAINT FK_REFUND_HANDLER_EMAIL FOREIGN KEY (HANDLER_EMAIL) -- FK
      REFERENCES MEMBER(EMAIL) ON DELETE SET NULL,

    CONSTRAINT CK_REFUND_STATUS CHECK (REFUND_STATUS IN ('��û','ó����','�Ϸ�','����')),
    CONSTRAINT CK_REFUND_IS_PARTIAL CHECK (IS_PARTIAL IN ('Y','N'))
);

CREATE SEQUENCE SEQ_REFUND_ID
START WITH 1 
INCREMENT BY 1
NOMAXVALUE 
NOMINVALUE
NOCYCLE 
NOCACHE;


/* =========================================================
   ������ı�? (REVIEWS)
   ========================================================= */
CREATE TABLE REVIEWS (
    REVIEW_NO        NUMBER          NOT NULL,             -- �ı���?(PK)
    EMAIL            VARCHAR2(100)   NOT NULL,             -- ȸ���̸���(FK)
    TRANSACTION_ID   NUMBER          NOT NULL,             -- ������ȣ(FK)
    RATING           NUMBER(2,1)     NOT NULL,             -- ����
    ONE_LINE_CAT     VARCHAR2(50)    NOT NULL,             -- ������ ī�װ���
    REVIEW_CONTENT   CLOB            NULL,                 -- ���䳻��
    CREATED_AT       DATE DEFAULT SYSDATE NOT NULL,        -- �ۼ���¥

    CONSTRAINT PK_REVIEWS PRIMARY KEY (REVIEW_NO),

    CONSTRAINT FK_REVIEWS_MEMBER FOREIGN KEY (EMAIL)
      REFERENCES MEMBER(EMAIL) ON DELETE CASCADE,

    CONSTRAINT FK_REVIEWS_TXN FOREIGN KEY (TRANSACTION_ID)
      REFERENCES TRANSACTIONS(TRANSACTION_ID) ON DELETE CASCADE,

    CONSTRAINT CK_REVIEWS_RATING CHECK (RATING BETWEEN 1 AND 5),
    CONSTRAINT UQ_REVIEWS_TXN UNIQUE (TRANSACTION_ID)
);

CREATE SEQUENCE SEQ_REVIEW_NO
START WITH 1 
INCREMENT BY 1
NOMAXVALUE 
NOMINVALUE
NOCYCLE 
NOCACHE;



/* =========================================================
   �Ű� (REPORTS)  - MESSAGES ���̺� �̻��?(=NoSQL �޽���)
   ========================================================= */
CREATE TABLE REPORTS (
    REPORT_ID        NUMBER PRIMARY KEY,                    -- �Ű���ȣ(PK)
    REPORTER_EMAIL   VARCHAR2(100) NOT NULL,                -- �Ű��� �̸���(FK)
    TARGET_EMAIL     VARCHAR2(100) NOT NULL,                -- �ǽŰ��� �̸���(FK)
    TYPE_ID          NUMBER NOT NULL,                       -- �Ű�����(FK)

    PRODUCT_NUM      NUMBER,                                -- ��ǰ��ȣ(FK)
    REVIEW_NUM       NUMBER,                                -- �ı���?(FK)

    ROOM_ID          VARCHAR2(100),                         -- ä�ù�Ű(FK: CHAT_ROOM.ROOM_ID)
    NOSQL_MSG_KEY    VARCHAR2(200),                         -- NoSQL �޽��� ����Ű/ID (FK �Ұ�)

    REPORT_DETAIL    VARCHAR2(600) NOT NULL,                -- �Ű�����
    REPORT_STATUS    VARCHAR2(20) DEFAULT '����' NOT NULL,   -- ó������
    REPORT_DATE      DATE DEFAULT SYSDATE NOT NULL,          -- �����Ͻ�
    REPORT_IMG       VARCHAR2(255),                         -- �����̹��� ���?

    CONSTRAINT FK_REP_REPORTER FOREIGN KEY (REPORTER_EMAIL) REFERENCES MEMBER(EMAIL),
    CONSTRAINT FK_REP_TARGET   FOREIGN KEY (TARGET_EMAIL)   REFERENCES MEMBER(EMAIL),
    CONSTRAINT FK_REP_TYPE     FOREIGN KEY (TYPE_ID)        REFERENCES REPORT_TYPES(TYPE_ID),

    CONSTRAINT FK_REP_PRODUCT  FOREIGN KEY (PRODUCT_NUM) REFERENCES PRODUCTS(PRODUCT_NO) ON DELETE SET NULL,
    CONSTRAINT FK_REP_REVIEW   FOREIGN KEY (REVIEW_NUM)  REFERENCES REVIEWS(REVIEW_NO)   ON DELETE SET NULL,

    CONSTRAINT FK_REP_ROOM     FOREIGN KEY (ROOM_ID) REFERENCES CHAT_ROOM(ROOM_ID) ON DELETE SET NULL,

    CONSTRAINT CK_REPORT_STATUS CHECK (REPORT_STATUS IN ('����','ó����','�Ϸ�')),

    -- �޽��� �Ű��� ROOM_ID + NOSQL_MSG_KEY �� �� �־��? ��(�� �� �ϳ��� ������ �ҿ���)
    CONSTRAINT CK_REPORT_MSG_PAIR CHECK (
        (ROOM_ID IS NULL AND NOSQL_MSG_KEY IS NULL)
     OR (ROOM_ID IS NOT NULL AND NOSQL_MSG_KEY IS NOT NULL)
    ),

    -- �Ű� �����? �ּ� 1���� �־��? �Ѵ�(��ǰ/�ı�/�޽���(ROOM_ID+NOSQL_MSG_KEY))
    CONSTRAINT CK_REPORT_TARGET_EXISTS CHECK (
        PRODUCT_NUM IS NOT NULL
     OR REVIEW_NUM  IS NOT NULL
     OR (ROOM_ID IS NOT NULL AND NOSQL_MSG_KEY IS NOT NULL)
    )
);

CREATE SEQUENCE SEQ_REPORT_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;




/* =========================================================
    ���� ���̺� (�����ڰ� ����/���� ����)
   ========================================================= */


CREATE TABLE ADS (
    AD_ID           NUMBER PRIMARY KEY,                 -- ���� ���� ��ȣ (PK)
    MANAGER_NAME    VARCHAR2(50) NOT NULL,              -- ��ü �����? �̸�
    COMPANY_EMAIL   VARCHAR2(100) NOT NULL,             -- ��ü �̸���
    PHONE           VARCHAR2(20) NOT NULL,              -- ��ü ����ó
    CONTENT         CLOB NOT NULL,                      -- ���� ���� �� �� ����
    START_DATE      DATE NOT NULL,                      -- ���� �Խ� ������
    END_DATE        DATE NOT NULL,                      -- ���� �Խ� ������
    DURATION_WEEKS  NUMBER(1) NOT NULL,                 -- ���� ���� �Ⱓ (1~4��)
    AMOUNT          NUMBER(15) DEFAULT 1000000 NOT NULL, -- ������
    FILE_PATH       VARCHAR2(500),                      -- ���� �̹��� ���? ���?
    AGREED_YN       VARCHAR2(1) DEFAULT 'Y' NOT NULL,       -- �������? (Y/N)
    STATUS          VARCHAR2(20) DEFAULT 'WAIT' NOT NULL,-- ���� (WAIT/CONFIRM/REJECT)
    REJECTED_REASON VARCHAR2(300),                      -- ���� ����
    CREATED_AT      DATE DEFAULT SYSDATE NOT NULL,      -- ��û��
    APPROVED_AT     DATE,                               -- ����/���� ó����

    -- [���� ����]
    CONSTRAINT CHK_AD_DURATION CHECK (DURATION_WEEKS BETWEEN 1 AND 4),
    CONSTRAINT CHK_AD_STATUS   CHECK (STATUS IN ('WAIT', 'CONFIRM', 'REJECT')),
    CONSTRAINT CHK_AD_DATE     CHECK (END_DATE > START_DATE),
    CONSTRAINT CHK_AD_AGREED   CHECK (AGREED_YN IN ('Y','N')),

    -- ���º� �ʼ��� ����(�ٽ�)
    CONSTRAINT CHK_AD_STATUS_DETAIL CHECK (
        (STATUS = 'WAIT'    AND APPROVED_AT IS NULL AND REJECTED_REASON IS NULL)
     OR (STATUS = 'CONFIRM' AND APPROVED_AT IS NOT NULL AND REJECTED_REASON IS NULL)
     OR (STATUS = 'REJECT'  AND APPROVED_AT IS NOT NULL AND REJECTED_REASON IS NOT NULL)
    )
);

CREATE SEQUENCE SEQ_AD_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


select *
from PRODUCTS;

delete PRODUCTS
where PRODUCT_NO = 8;

commit;

select *
from member;

desc REPORT_TYPES;

select *
from REPORT_TYPES;

select *
from REPORTS;

DROP TABLE REPORTS;

commit;

CREATE TABLE REPORTS (
    REPORT_ID        NUMBER PRIMARY KEY,                    -- �Ű���ȣ(PK)
    REPORTER_EMAIL   VARCHAR2(100) NOT NULL,                -- �Ű��� �̸���(FK)
    TARGET_EMAIL     VARCHAR2(100) NOT NULL,                -- �ǽŰ��� �̸���(FK)
    TYPE_ID          NUMBER NOT NULL,                       -- �Ű�����(FK)

    PRODUCT_NUM      NUMBER,                                -- ��ǰ��ȣ(FK)
    REVIEW_NUM       NUMBER,                                -- �ı���?(FK)

    ROOM_ID          VARCHAR2(100),                         -- ä�ù�Ű(FK: CHAT_ROOM.ROOM_ID)
    NOSQL_MSG_KEY    VARCHAR2(200),                         -- NoSQL �޽��� ����Ű/ID (FK �Ұ�)

    REPORT_DETAIL    VARCHAR2(600) NOT NULL,                -- �Ű�����
    REPORT_STATUS    VARCHAR2(20) DEFAULT '����' NOT NULL,   -- ó������
    REPORT_DATE      DATE DEFAULT SYSDATE NOT NULL,         -- �����Ͻ�
    REPORT_IMG       VARCHAR2(255),                         -- �����̹��� ���?

    CONSTRAINT FK_REP_REPORTER FOREIGN KEY (REPORTER_EMAIL) REFERENCES MEMBER(EMAIL),
    CONSTRAINT FK_REP_TARGET   FOREIGN KEY (TARGET_EMAIL)   REFERENCES MEMBER(EMAIL),
    CONSTRAINT FK_REP_TYPE     FOREIGN KEY (TYPE_ID)        REFERENCES REPORT_TYPES(TYPE_ID),

    CONSTRAINT FK_REP_PRODUCT  FOREIGN KEY (PRODUCT_NUM) REFERENCES PRODUCTS(PRODUCT_NO) ON DELETE SET NULL,
    CONSTRAINT FK_REP_REVIEW   FOREIGN KEY (REVIEW_NUM)  REFERENCES REVIEWS(REVIEW_NO)   ON DELETE SET NULL,
    CONSTRAINT FK_REP_ROOM     FOREIGN KEY (ROOM_ID) REFERENCES CHAT_ROOM(ROOM_ID) ON DELETE SET NULL,

    CONSTRAINT CK_REPORT_STATUS CHECK (REPORT_STATUS IN ('����','ó����','�Ϸ�')),

    CONSTRAINT CK_REPORT_MSG_PAIR CHECK (
        (NOSQL_MSG_KEY IS NOT NULL AND ROOM_ID IS NOT NULL) 
        OR (NOSQL_MSG_KEY IS NULL)
    ),

    CONSTRAINT CK_REPORT_TARGET_EXISTS CHECK (
        PRODUCT_NUM IS NOT NULL
     OR REVIEW_NUM  IS NOT NULL
     OR ROOM_ID IS NOT NULL
    )
);

CREATE SEQUENCE SEQ_REPORT_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

commit;
DROP TABLE REPORTS CASCADE CONSTRAINTS;

-- ? �����̾��� �������� ���� �����?
DROP SEQUENCE SEQ_REPORT_ID;


select *
from PRODUCTS;

select *
from member;

update member set email = 'dltlgud112@naver.com'
WHERE PHONE = '01045261348';

commit;

ALTER TABLE MEMBER MODIFY PHONE VARCHAR2(100);
ALTER TABLE USER_DORMANT MODIFY PHONE VARCHAR2(100);

UPDATE MEMBER
  SET LAST_LOGIN_DATE = ADD_MONTHS(SYSDATE, -14)
  WHERE EMAIL = 'dltlgud112@naver.com';
  
  commit;
  
  select *
  from member;
  
  
  UPDATE MEMBER
  SET status = 1
  WHERE EMAIL = 'dltlgud999@naver.com';
  COMMIT;
  
  select *
  from USER_DORMANT;

/* =========================================================
   PRODUCTS ?��?��블에 ?��?��?�� 채팅�? ID 컬럼 추�?
   - ?��?�� ?��?�� ?�� ?��?�� 채팅�?(구매?��)?�� ?��?��?��?��?���? 추적
   ========================================================= */
ALTER TABLE PRODUCTS ADD RESERVED_ROOM_ID VARCHAR2(100);
COMMIT;

  SELECT EMAIL, PHONE, STATUS, IDLE FROM MEMBER WHERE EMAIL = 'dltlgud112@naver.com';
  
  
  ALTER TABLE DELIVERY_ADDRESS ADD IS_PRIMARY VARCHAR2(1) DEFAULT 'N' NOT NULL CHECK (IS_PRIMARY IN ('Y','N'));
  commit;
  select *
  from DELIVERY_ADDRESS;
  
  select *
  from ACCOUNTS;
  
  update TRANSACTIONS set TRADE_STATUS = '�ŷ��Ϸ�' where TRANSACTION_ID = 112;
  
  commit;
  
  ALTER TABLE MEMBER ADD (
      SOCIAL_TYPE VARCHAR2(20) DEFAULT NULL,
      SOCIAL_ID   VARCHAR2(100) DEFAULT NULL
  );
  
  commit;
  
  delete member 
  where email = 'dltlgud693@naver.com';
  
  select *
  from member;
  
  update member set STATUS = 1
  where email = 'dltlgud691@naver.com';
  
  commit;
  
  ALTER TABLE CHAT_ROOM ADD BUYER_UNREAD NUMBER DEFAULT 0;
  ALTER TABLE CHAT_ROOM ADD SELLER_UNREAD NUMBER DEFAULT 0;
  UPDATE CHAT_ROOM SET BUYER_UNREAD = 0, SELLER_UNREAD = 0;
  COMMIT;
  
  ALTER TABLE PRODUCTS ADD CARRIER_CODE VARCHAR2(10);
  ALTER TABLE PRODUCTS ADD INVOICE_NO VARCHAR2(50);
  commit;
  
  desc member;
  
  ALTER TABLE TRANSACTIONS ADD CARRIER_CODE VARCHAR2(10);
  ALTER TABLE TRANSACTIONS ADD INVOICE_NO VARCHAR2(50);
  COMMIT;
  
   SELECT col.table_name, col.column_name, col.data_type,
         col.nullable,
         CASE WHEN pk.column_name IS NOT NULL THEN 'PK' END AS pk,
         CASE WHEN fk.column_name IS NOT NULL THEN 'FK �� ' || fk.ref_table END AS fk
  FROM user_tab_columns col
  LEFT JOIN (
      SELECT c.table_name, cc.column_name
      FROM user_constraints c JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
      WHERE c.constraint_type = 'P'
  ) pk ON col.table_name = pk.table_name AND col.column_name = pk.column_name
  LEFT JOIN (
      SELECT a.table_name, a.column_name, b.table_name AS ref_table
      FROM user_cons_columns a
      JOIN user_constraints c ON a.constraint_name = c.constraint_name
      JOIN user_cons_columns b ON c.r_constraint_name = b.constraint_name
      WHERE c.constraint_type = 'R'
  ) fk ON col.table_name = fk.table_name AND col.column_name = fk.column_name
  ORDER BY col.table_name, col.column_id;
  
  
    ALTER TABLE TRANSACTIONS DROP CONSTRAINT CK_TXN_PAYMENT_TYPE;
  ALTER TABLE TRANSACTIONS ADD CONSTRAINT CK_TXN_PAYMENT_TYPE CHECK (
    PAYMENT_TYPE IN ('��������','ĳ�ð���','ī�����','�������','�������','���ŷ�','����')
  );

  ALTER TABLE TRANSACTIONS DROP CONSTRAINT CK_TXN_TOSS_MINIMAL;
  ALTER TABLE TRANSACTIONS ADD CONSTRAINT CK_TXN_TOSS_MINIMAL CHECK (
    (PAYMENT_TYPE IN ('ī�����','�������','�������')
      AND TOSS_ORDER_ID IS NOT NULL
      AND TOSS_PAY_KEY  IS NOT NULL)
    OR
    (PAYMENT_TYPE IN ('��������','ĳ�ð���','���ŷ�','����')
      AND TOSS_ORDER_ID IS NULL
      AND TOSS_PAY_KEY  IS NULL)
  );

  COMMIT;
  
  select *
  from member;
  
  select *
  from products;
  
  delete from products
  where product_no = 125;
  
  select *
  from TRANSACTIONS;
  
  delete from TRANSACTIONS
  where product_no = 125;
  
  select *
  from CHAT_ROOM;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ---------------------------------------------------------------------------------------------
  
  show user;
-- USER��(��) "SYS"�Դϴ�.

alter session set "_ORACLE_SCRIPT"=true;
-- Session��(��) ����Ǿ����ϴ�.

--  final_orauser1
--  final_orauser2
--  final_orauser3 �̶�� ����Ŭ �Ϲݻ���� ������ �����մϴ�. ��ȣ�� sistsix ��� �ϰڽ��ϴ�.
--create user final_orauser1 identified by sistsix default tablespace users;
-- create user final_orauser2 identified by sistsix default tablespace users;
create user semi_orauser3 identified by sistsix default tablespace users;

-- User FINAL_ORAUSER1��(��) �����Ǿ����ϴ�.


-- �����Ǿ��� ����Ŭ �Ϲݻ���� ������ final_orauser1 ���� ����Ŭ������ ������ �Ǿ�����, 
-- ������ �Ǿ��� �� ���̺� ���� ������ �� �ֵ��� ������ �ο����ְڴ�.
grant connect, resource, unlimited tablespace to final_orauser1;
-- grant connect, resource, unlimited tablespace to final_orauser2;
grant connect, resource, unlimited tablespace to semi_orauser3;

-- Grant��(��) �����߽��ϴ�.

show user;
-- USER��(��) "FINAL_ORAUSER1"�Դϴ�.

