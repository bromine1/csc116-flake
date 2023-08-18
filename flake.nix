{
  description = "My collection of personal flake templates";

  outputs = {self}: {
    templates = {
      csc-116 = {
        path = ./csc116;
        description = "flake for ncsu csc 116 requirements";
      };
    };
  };
}
