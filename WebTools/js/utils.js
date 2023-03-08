/**
 * 从身份证号提取生日
 * @param {string} idno
 * @returns {string} format:YYYY-MM-DD
 */
export function getDOBFromIDNo(idno) {
  if (!idno) return null;
  if (!isNaN(idno)) idno = idno.toString();
  if (idno.length === 18) {
    let matchResult = /(\d{6})(\d{4})(\d{2})(\d{2})(.*)/.exec(idno);
    if (matchResult) {
      return `${matchResult[2]}-${matchResult[3]}-${matchResult[4]}`;
    }
    return null;
  } else if (idno.length === 15) {
    let matchResult = /(\d{6})(\d{2})(\d{2})(\d{2})(.*)/.exec(idno);
    if (matchResult) {
      return `19${matchResult[2]}-${matchResult[3]}-${matchResult[4]}`;
    }
  } else return null;
}

/**
 *
 * @param {string} idno
 * @returns {int} gender
 */
export function getGenderFromIDNo(idno) {
  if (!idno) return null;
  if (idno.length === 18) return idno.at(16) % 2 ? 1 : 2;
  else if (idno.length === 15) return idno.at(14) % 2 ? 1 : 2;
  else return null;
}

/**
 *
 * @param {string} e
 * @returns {boolean}
 */
String.isNullOrEmpty = function (e) {
  return (e ?? "").toString().trim().length <= 0;
};
String.prototype.isNullOrEmpty = function (e) {
  return String.isNullOrEmpty(e);
};
/**
 * 数字前补零
 * e.g paddingZero(13, 3) ===> 013
 * @param {Number} num
 * @param {Number} length
 * @returns String
 */
export function paddingZero(num, length) {
  for (var len = (num + "").length; len < length; len = num.length) {
    num = "0" + num;
  }
  return num;
}

export function guid() {
  function S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  }
  return (
    S4() +
    S4() +
    "-" +
    S4() +
    "-" +
    S4() +
    "-" +
    S4() +
    "-" +
    S4() +
    S4() +
    S4()
  );
}

/**
 * 从文件获取文件的MIMEType
 * @param {File} fileStream 
 * @param {Function} callBack 
 */
export function checkMIMEType(fileStream, callBack) {
  const reader = new FileReader();
  let finalType = "";

  reader.onloadend = () => {
    const arr = new Uint8Array(reader.result).subarray(0, 4);
    let header = "";
    for (let i = 0; i < arr.length; i++) {
      header += arr[i].toString(16);
    }

    switch (header) {
      case "89504e47":
        finalType = "image/png";
        callBack(finalType);
      case "47494638":
        finalType = "image/gif";
        callBack(finalType);
      case "ffd8ffDB":
      case "ffd8ffe0":
      case "ffd8ffe1":
      case "ffd8ffe2":
      case "ffd8ffe3":
      case "ffd8ffe8":
        finalType = "image/jpeg";
        callBack(finalType);
      default:
        callBack(finalType);
    }
  };

  reader.readAsArrayBuffer(fileStream);
}


export function getMaxZIndex() {
  return Array.from(document.querySelectorAll("*")).reduce((a, x) => {
      let cs = window.getComputedStyle(x, null);
      let z = +(cs.zIndex || "1");
      z = cs.display == "none" || cs.opacity == "0" ? 1 : z;

      if (isNaN(z))
          z = 1;
      else if (z > 10000000)
          z = 1;

      return Math.max(a, z);
  }, 1);
}