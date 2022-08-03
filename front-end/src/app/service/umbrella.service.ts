import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, EMPTY, Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UmbrellaService {
  umbrellaUrl: string;

  constructor(private http: HttpClient) {
    this.umbrellaUrl = `${environment.apiUrl}/umbrella`;
  }

  getUmbrellaBy(mncp: string): Observable<any> {
    const url = `${this.umbrellaUrl}/${mncp}`;
    return this.http.get<any>(url).pipe(catchError(() => EMPTY));
  }
}
