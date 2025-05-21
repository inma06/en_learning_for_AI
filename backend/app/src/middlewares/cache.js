const mcache = require('memory-cache');

const cache = (duration) => {
  return (req, res, next) => {
    // GET 요청만 캐싱
    if (req.method !== 'GET') {
      return next();
    }

    const key = '__express__' + req.originalUrl || req.url;
    const cachedBody = mcache.get(key);

    if (cachedBody) {
      res.send(cachedBody);
      return;
    }

    // 응답을 보내기 전에 캐시에 저장
    res.sendResponse = res.send;
    res.send = (body) => {
      mcache.put(key, body, duration * 1000);
      res.sendResponse(body);
    };
    next();
  };
};

module.exports = cache; 