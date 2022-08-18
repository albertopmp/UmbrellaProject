import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, EMPTY, map, Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { UmbrellaData } from '../model/umbrella-data';

@Injectable({
  providedIn: 'root'
})
export class UmbrellaService {
  umbrellaUrl: string;

  constructor(private http: HttpClient) {
    this.umbrellaUrl = `${environment.apiUrl}`;
  }

  getUmbrellaBy(mncp: string): Observable<UmbrellaData> {
    const url = `${this.umbrellaUrl}/umbrella/${mncp}`;
    return this.http.get<UmbrellaData>(url).pipe(catchError(() => EMPTY));
  }

  getTotalSubscribers(): Observable<number> {
    const url = `${this.umbrellaUrl}/subscribers/count`;
    return this.http.get(url, { responseType: 'text' }).pipe(map((value) => Number(value)));
  }

  subscribeToTopicBy(email: string): Observable<any> {
    const url = `${this.umbrellaUrl}/subscribers/${email}`;
    return this.http.post<void>(url, email).pipe(
      catchError(() => {
        throw new Error('Unable to subscribe');
      })
    );
  }
}
