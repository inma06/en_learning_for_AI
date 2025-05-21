const express = require('express');
const router = express.Router();
const learningMaterialController = require('../controllers/learningMaterialController');
const { protect, admin } = require('../middlewares/auth');

// 학습자료 등록 (관리자만)
router.post('/', protect, admin, learningMaterialController.createMaterial);
// 전체 조회
router.get('/', learningMaterialController.getAllMaterials);
// 단건 조회
router.get('/:id', learningMaterialController.getMaterialById);
// 수정 (관리자만)
router.put('/:id', protect, admin, learningMaterialController.updateMaterial);
// 삭제 (관리자만)
router.delete('/:id', protect, admin, learningMaterialController.deleteMaterial);

module.exports = router; 