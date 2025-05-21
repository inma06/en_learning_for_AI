"use strict";
/*
 * ATTENTION: An "eval-source-map" devtool has been used.
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file with attached SourceMaps in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
exports.id = "vendor-chunks/@chakra-ui+react-use-callback-ref@2.1.0_react@18.3.1";
exports.ids = ["vendor-chunks/@chakra-ui+react-use-callback-ref@2.1.0_react@18.3.1"];
exports.modules = {

/***/ "(ssr)/../../node_modules/.pnpm/@chakra-ui+react-use-callback-ref@2.1.0_react@18.3.1/node_modules/@chakra-ui/react-use-callback-ref/dist/index.mjs":
/*!***************************************************************************************************************************************************!*\
  !*** ../../node_modules/.pnpm/@chakra-ui+react-use-callback-ref@2.1.0_react@18.3.1/node_modules/@chakra-ui/react-use-callback-ref/dist/index.mjs ***!
  \***************************************************************************************************************************************************/
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export */ __webpack_require__.d(__webpack_exports__, {\n/* harmony export */   useCallbackRef: () => (/* binding */ useCallbackRef)\n/* harmony export */ });\n/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react */ \"(ssr)/../../node_modules/.pnpm/next@14.1.0_react-dom@18.3.1_react@18.3.1__react@18.3.1/node_modules/next/dist/server/future/route-modules/app-page/vendored/ssr/react.js\");\n/* __next_internal_client_entry_do_not_use__ useCallbackRef auto */ // src/index.ts\n\nfunction useCallbackRef(callback, deps = []) {\n    const callbackRef = (0,react__WEBPACK_IMPORTED_MODULE_0__.useRef)(callback);\n    (0,react__WEBPACK_IMPORTED_MODULE_0__.useEffect)(()=>{\n        callbackRef.current = callback;\n    });\n    return (0,react__WEBPACK_IMPORTED_MODULE_0__.useCallback)((...args)=>{\n        var _a;\n        return (_a = callbackRef.current) == null ? void 0 : _a.call(callbackRef, ...args);\n    }, deps);\n}\n //# sourceMappingURL=index.mjs.map\n//# sourceURL=[module]\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiKHNzcikvLi4vLi4vbm9kZV9tb2R1bGVzLy5wbnBtL0BjaGFrcmEtdWkrcmVhY3QtdXNlLWNhbGxiYWNrLXJlZkAyLjEuMF9yZWFjdEAxOC4zLjEvbm9kZV9tb2R1bGVzL0BjaGFrcmEtdWkvcmVhY3QtdXNlLWNhbGxiYWNrLXJlZi9kaXN0L2luZGV4Lm1qcyIsIm1hcHBpbmdzIjoiOzs7OztvRUFFQSxlQUFlO0FBQ3dDO0FBQ3ZELFNBQVNHLGVBQWVDLFFBQVEsRUFBRUMsT0FBTyxFQUFFO0lBQ3pDLE1BQU1DLGNBQWNKLDZDQUFNQSxDQUFDRTtJQUMzQkgsZ0RBQVNBLENBQUM7UUFDUkssWUFBWUMsT0FBTyxHQUFHSDtJQUN4QjtJQUNBLE9BQU9KLGtEQUFXQSxDQUFDLENBQUMsR0FBR1E7UUFDckIsSUFBSUM7UUFDSixPQUFPLENBQUNBLEtBQUtILFlBQVlDLE9BQU8sS0FBSyxPQUFPLEtBQUssSUFBSUUsR0FBR0MsSUFBSSxDQUFDSixnQkFBZ0JFO0lBQy9FLEdBQUdIO0FBQ0w7QUFHRSxDQUNGLGtDQUFrQyIsInNvdXJjZXMiOlsid2VicGFjazovL3dlYi1hZG1pbi8uLi8uLi9ub2RlX21vZHVsZXMvLnBucG0vQGNoYWtyYS11aStyZWFjdC11c2UtY2FsbGJhY2stcmVmQDIuMS4wX3JlYWN0QDE4LjMuMS9ub2RlX21vZHVsZXMvQGNoYWtyYS11aS9yZWFjdC11c2UtY2FsbGJhY2stcmVmL2Rpc3QvaW5kZXgubWpzP2Y2YjkiXSwic291cmNlc0NvbnRlbnQiOlsiJ3VzZSBjbGllbnQnXG5cbi8vIHNyYy9pbmRleC50c1xuaW1wb3J0IHsgdXNlQ2FsbGJhY2ssIHVzZUVmZmVjdCwgdXNlUmVmIH0gZnJvbSBcInJlYWN0XCI7XG5mdW5jdGlvbiB1c2VDYWxsYmFja1JlZihjYWxsYmFjaywgZGVwcyA9IFtdKSB7XG4gIGNvbnN0IGNhbGxiYWNrUmVmID0gdXNlUmVmKGNhbGxiYWNrKTtcbiAgdXNlRWZmZWN0KCgpID0+IHtcbiAgICBjYWxsYmFja1JlZi5jdXJyZW50ID0gY2FsbGJhY2s7XG4gIH0pO1xuICByZXR1cm4gdXNlQ2FsbGJhY2soKC4uLmFyZ3MpID0+IHtcbiAgICB2YXIgX2E7XG4gICAgcmV0dXJuIChfYSA9IGNhbGxiYWNrUmVmLmN1cnJlbnQpID09IG51bGwgPyB2b2lkIDAgOiBfYS5jYWxsKGNhbGxiYWNrUmVmLCAuLi5hcmdzKTtcbiAgfSwgZGVwcyk7XG59XG5leHBvcnQge1xuICB1c2VDYWxsYmFja1JlZlxufTtcbi8vIyBzb3VyY2VNYXBwaW5nVVJMPWluZGV4Lm1qcy5tYXAiXSwibmFtZXMiOlsidXNlQ2FsbGJhY2siLCJ1c2VFZmZlY3QiLCJ1c2VSZWYiLCJ1c2VDYWxsYmFja1JlZiIsImNhbGxiYWNrIiwiZGVwcyIsImNhbGxiYWNrUmVmIiwiY3VycmVudCIsImFyZ3MiLCJfYSIsImNhbGwiXSwic291cmNlUm9vdCI6IiJ9\n//# sourceURL=webpack-internal:///(ssr)/../../node_modules/.pnpm/@chakra-ui+react-use-callback-ref@2.1.0_react@18.3.1/node_modules/@chakra-ui/react-use-callback-ref/dist/index.mjs\n");

/***/ })

};
;