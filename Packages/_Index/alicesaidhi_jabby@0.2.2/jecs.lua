local REQUIRED_MODULE = require(script.Parent.Parent["ukendio_jecs@0.5.5"]["jecs"])
export type Archetype = REQUIRED_MODULE.Archetype 
export type Record = REQUIRED_MODULE.Record 
export type Entity<T > = REQUIRED_MODULE.Entity<T >
export type Id<T > =
REQUIRED_MODULE.Id<T >
export type Pair<P, O> = REQUIRED_MODULE.Pair<P, O>
export type Query<T...> = REQUIRED_MODULE.Query<T...>
export type Observer = REQUIRED_MODULE.Observer 
export type World = REQUIRED_MODULE.World 
return REQUIRED_MODULE
