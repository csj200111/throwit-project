-- ============================================
-- Thowit - 대형폐기물 배출 도우미 DB 스키마
-- Database: waste_db
-- Charset: utf8mb4
-- ============================================

-- 대형폐기물 수수료 테이블 (공공데이터)
CREATE TABLE IF NOT EXISTS large_waste_fee (
  id BIGINT NOT NULL AUTO_INCREMENT,
  시도명 VARCHAR(255) DEFAULT NULL,
  시군구명 VARCHAR(255) DEFAULT NULL,
  대형폐기물명 VARCHAR(255) DEFAULT NULL,
  대형폐기물구분명 VARCHAR(255) DEFAULT NULL,
  대형폐기물규격 VARCHAR(255) DEFAULT NULL,
  유무료여부 VARCHAR(255) DEFAULT NULL,
  수수료 INT DEFAULT NULL,
  관리기관명 VARCHAR(255) DEFAULT NULL,
  데이터기준일자 DATE DEFAULT NULL,
  제공기관코드 VARCHAR(20) DEFAULT NULL,
  제공기관명 VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_시도명 (시도명),
  KEY idx_시군구명 (시군구명),
  KEY idx_대형폐기물명 (대형폐기물명)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 폐기물 처리시설 테이블 (공공데이터)
CREATE TABLE IF NOT EXISTS waste_facility (
  id BIGINT NOT NULL AUTO_INCREMENT,
  시설명 VARCHAR(255) DEFAULT NULL,
  소재지도로명주소 VARCHAR(255) DEFAULT NULL,
  소재지지번주소 VARCHAR(255) DEFAULT NULL,
  위도 DECIMAL(38,2) DEFAULT NULL,
  경도 DECIMAL(38,2) DEFAULT NULL,
  업종명 VARCHAR(255) DEFAULT NULL,
  전문처리분야명 VARCHAR(255) DEFAULT NULL,
  처리폐기물정보 VARCHAR(255) DEFAULT NULL,
  영업구역 VARCHAR(255) DEFAULT NULL,
  시설장비명 VARCHAR(255) DEFAULT NULL,
  허가일자 DATE DEFAULT NULL,
  전화번호 VARCHAR(255) DEFAULT NULL,
  관리기관명 VARCHAR(255) DEFAULT NULL,
  데이터기준일자 DATE DEFAULT NULL,
  제공기관코드 VARCHAR(255) DEFAULT NULL,
  제공기관명 VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_시설명 (시설명),
  KEY idx_업종명 (업종명),
  KEY idx_소재지도로명주소 (소재지도로명주소(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 사용자 테이블
CREATE TABLE IF NOT EXISTS users (
  id BIGINT NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  salt VARCHAR(255) NOT NULL,
  nickname VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 배출 신청 테이블
CREATE TABLE IF NOT EXISTS disposal_applications (
  id BIGINT NOT NULL AUTO_INCREMENT,
  application_number VARCHAR(20) NOT NULL UNIQUE,
  user_id BIGINT NOT NULL,
  sido VARCHAR(50) NOT NULL,
  sigungu VARCHAR(50) NOT NULL,
  disposal_address VARCHAR(255) NOT NULL,
  preferred_date DATE NOT NULL,
  total_fee INT NOT NULL DEFAULT 0,
  status ENUM('PENDING_PAYMENT','PAID','COLLECTED','CANCELLED','REFUNDED') NOT NULL DEFAULT 'PENDING_PAYMENT',
  payment_method ENUM('CARD','WIRE_TRANSFER') DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 배출 품목 테이블
CREATE TABLE IF NOT EXISTS disposal_items (
  id BIGINT NOT NULL AUTO_INCREMENT,
  application_id BIGINT NOT NULL,
  waste_item_name VARCHAR(255) NOT NULL,
  size_label VARCHAR(100) DEFAULT NULL,
  quantity INT NOT NULL DEFAULT 1,
  fee INT NOT NULL DEFAULT 0,
  photo_url VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_application_id (application_id),
  CONSTRAINT fk_disposal_items_application
    FOREIGN KEY (application_id) REFERENCES disposal_applications(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 재활용 물품 테이블
CREATE TABLE IF NOT EXISTS recycle_items (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  photos LONGTEXT DEFAULT NULL,
  sido VARCHAR(50) DEFAULT NULL,
  sigungu VARCHAR(50) DEFAULT NULL,
  address VARCHAR(255) DEFAULT NULL,
  lat DECIMAL(10,7) DEFAULT NULL,
  lng DECIMAL(10,7) DEFAULT NULL,
  status ENUM('AVAILABLE','RESERVED','SOLD','WITHDRAWN') NOT NULL DEFAULT 'AVAILABLE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sido (sido),
  KEY idx_sigungu (sigungu),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
