fun_env <- function(f) {
    envs <- c(.GlobalEnv, lapply(loadedNamespaces(), .getNamespace))
    for (env in envs) {
        if (exists(f, env, inherits = FALSE))
            return(environmentName(env))
    }
    return(NA)
}