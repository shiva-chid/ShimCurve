
/*
label, text, label of the order D.d-?
i_square, integer, i^2
j_square, integer, j^2
discO, integer, (reduced) discriminant (O)
discB, integer, discriminant(B)
gens_numerators, integer[], a list L of lists such that L[j] are the coefficients of 1,i,j,k of the numerator of an element of B.
gens_denominators, integer[], a list of denominators, so that gensOnumerators[j] / gensOdenominators[j] is a generator of O for all j.
*/

intrinsic LMFDBLabel(O::AlgQuatOrd) -> MonStgElt
  {Given a quaternion order O, generate its LMFDB label}
  
  if IsMaximal(O) then 
    B := QuaternionAlgebra(O);
    D := Discriminant(B);
    return Sprintf("%o",D);
  else 
    print "Only works for O maximal at the moment";
  end if;
  
end intrinsic;


intrinsic LMFDBRowEntry(O::AlgQuatOrd) -> MonStgElt
  {return the row of data associated to O which will become part of the LMFDB schema.
  The schema is (for O maximal):
  LMFDBLabel(O) ? a ? b ? disc(O) ? disc(B) ? coefficients of Basis(O) in terms of i,j,k scaled to be integral ? 1/b where b multiplied by the corresponding element in the previous column is the basis element}

  if not(IsMaximal(O)) then 
    return "Only works for O maximal at the moment";
  end if;

  B:=QuaternionAlgebra(O);
  D:=Discriminant(B);
  d:= Discriminant(O);
  gensO:=Generators(O);
  gensOijk:=[ Eltseq(elt) : elt in gensO ];
  denominatorsLCM:=[ LCM([Denominator(a) : a in seq]) : seq in gensOijk ];
  gensOijk_integral:=[ [ (denominatorsLCM[i])*gensOijk[i][j] : j in [1..4] ] : i in [1..4] ];
  gensOijk_integral_str := [ Sprintf("%o",lst) : lst in gensOijk_integral ];
  gensOijk_integral_str := Sprint(gensOijk_integral_str);
  //gensOijk_integral_str := ReplaceString(gensOijk_integral_str,"[","{");
  //gensOijk_integral_str := ReplaceString(gensOijk_integral_str,"]","}");
  

  label:=LMFDBLabel(O);
  a,b:=StandardForm(B);

  return Sprintf("%o ? %o ? %o ? %o ? %o ? %o ? %o",label,a,b,D,d,gensOijk_integral_str,denominatorsLCM);
end intrinsic;



intrinsic EnumerateO(bound::RngIntElt : verbose:=true,write:=false) -> Any
  {loop over maximal orders of discriminant up to bound and output their lmfdb row entry}
  
  if write eq true then 
    filename:=Sprintf("ShimCurve/data/quaternion-orders/quaternion-orders.m");
    Write(filename, Sprint("label ? i_square ? j_square ? discO ? discB ? gens_numerators ? gens_denominators"));
    Write(filename, Sprint("text ? integer ? integer ? integer ? integer ? integer[] ? integer[]\n"));
  end if;

  for D in [6..bound] do 
    if IsSquarefree(D) and IsEven(#PrimeDivisors(D)) then 
      B:=QuaternionAlgebra(D);
      O:=MaximalOrder(B);
      row:=LMFDBRowEntry(O);
      if verbose eq true then 
        row;
      end if;
      if write eq true then 
        filename:=Sprintf("ShimCurve/data/quaternion-orders/quaternion-orders.m");
        Write(filename,row);   
      end if;
    end if;
  end for;
  return "";
end intrinsic;




intrinsic LMFDBLabel(O::AlgQuatOrd,mu::AlgQuatElt) -> MonStgElt
  {Given a quaternion order O, generate its LMFDB label}
  
  if IsMaximal(O) then 
    B := QuaternionAlgebra(O);
    D := Discriminant(B);
    del:=DegreeOfPolarizedElement(O,mu);
    return Sprintf("%o.%o",D,del);
  else 
    print "Only works for O maximal at the moment";
  end if;
  
end intrinsic;



