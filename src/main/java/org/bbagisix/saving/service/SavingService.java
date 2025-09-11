package org.bbagisix.saving.service;

import java.util.List;

import org.bbagisix.asset.domain.AssetVO;
import org.bbagisix.asset.mapper.AssetMapper;
import org.bbagisix.challenge.domain.UserChallengeVO;
import org.bbagisix.challenge.mapper.ChallengeMapper;
import org.bbagisix.common.exception.BusinessException;
import org.bbagisix.common.exception.ErrorCode;
import org.bbagisix.saving.dto.SavingDTO;
import org.bbagisix.saving.mapper.SavingMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
@RequiredArgsConstructor
public class SavingService {

	private final SavingMapper savingMapper;
	private final ChallengeMapper challengeMapper;
	private final AssetMapper assetMapper;

	public List<SavingDTO> getSavingHistory(Long userId) {
		try {
			return savingMapper.getSavingHistory(userId);
		} catch (Exception e) {
			log.error("사용자 저금 내역 조회 중 오류 발생: userId={}, error={}", userId, e.getMessage(), e);
			throw new BusinessException(ErrorCode.DATA_ACCESS_ERROR, e);
		}
	}

	public Long getTotalSaving(Long userId) {
		try {
			return savingMapper.getTotalSaving(userId);
		} catch (Exception e) {
			log.error("사용자 총 저금액 조회 중 오류 발생: userId={}, error={}", userId, e.getMessage(), e);
			throw new BusinessException(ErrorCode.DATA_ACCESS_ERROR, e);
		}
	}

	@Transactional(rollbackFor = Exception.class, isolation = Isolation.READ_COMMITTED)
	public void updateSaving(Long userId, Long userChallengeId) {

		// 해당 userChallenge 조회
		UserChallengeVO userChallenge;
		userChallenge = challengeMapper.getUserChallengeById(userChallengeId);
		if (userChallenge == null)
			throw new BusinessException(ErrorCode.CHALLENGE_NOT_FOUND);
		if (!userChallenge.getUserId().equals(userId))
			throw new BusinessException(ErrorCode.SAVING_UPDATE_DENIED);

		Long totalSaving = userChallenge.getSaving() * userChallenge.getPeriod();

		// saving ledger insert(저금내역 저장 및 멱등처리)
		try{
			savingMapper.insertSavingLedger(userChallengeId,userId,totalSaving);
		}catch(org.springframework.dao.DuplicateKeyException e){ // 중복키가 있을 시 리턴
			log.info("Idempotent hit: userChallengeId={} userId={}", userChallengeId, userId);
			return;
		}

		// balance update
		int updated = assetMapper.updateSavingAssetBalance(userId, totalSaving);
		if (updated != 1) {
			throw new BusinessException(ErrorCode.SAVING_UPDATE_FAILED);
		}

	}

}
