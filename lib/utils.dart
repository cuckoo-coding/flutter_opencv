class Utils {
  static List<double> verifyKernelSize(List<double> kernelSize) {
    List<double> response = [1, 1];

    (kernelSize[0] <= 0) ? response[0] = 1 : response[0] = kernelSize[0];

    (kernelSize[1] <= 0) ? response[1] = 1 : response[1] = kernelSize[1];

    return response;
  }

  static int verifyBorderType(int borderType) {
    return (borderType <= 0)
        ? 0
        : (borderType <= 5)
            ? borderType
            : 16;
  }
}
