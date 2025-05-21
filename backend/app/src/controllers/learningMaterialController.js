const LearningMaterial = require('../models/LearningMaterial');

// 학습자료 등록
exports.createMaterial = async (req, res) => {
  try {
    const material = await LearningMaterial.create(req.body);
    res.status(201).json(material);
  } catch (error) {
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
};

// 전체 조회
exports.getAllMaterials = async (req, res) => {
  try {
    const materials = await LearningMaterial.find().sort({ createdAt: -1 });
    res.json(materials);
  } catch (error) {
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
};

// 단건 조회
exports.getMaterialById = async (req, res) => {
  try {
    const material = await LearningMaterial.findById(req.params.id);
    if (!material) return res.status(404).json({ message: '자료를 찾을 수 없습니다.' });
    res.json(material);
  } catch (error) {
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
};

// 수정
exports.updateMaterial = async (req, res) => {
  try {
    const material = await LearningMaterial.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!material) return res.status(404).json({ message: '자료를 찾을 수 없습니다.' });
    res.json(material);
  } catch (error) {
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
};

// 삭제
exports.deleteMaterial = async (req, res) => {
  try {
    const material = await LearningMaterial.findByIdAndDelete(req.params.id);
    if (!material) return res.status(404).json({ message: '자료를 찾을 수 없습니다.' });
    res.json({ message: '삭제되었습니다.' });
  } catch (error) {
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
}; 